import UIKit
import CoreData

final class TrackerCategoryStore {
    
    private let appDelegate = AppDelegate()
    private let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
    private var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func addCategory(name: String) {
        let category = TrackerCategory(title: name, trackers: [])
        let categoryCoreData = TrackerCategoryCoreData(context: context)
        categoryCoreData.title = category.title
        appDelegate.saveContext(context: context)
    }
    
    func addCategory(_ category: TrackerCategory) {
        let categoryCoreData = TrackerCategoryCoreData(context: context)
        categoryCoreData.title = category.title
        appDelegate.saveContext(context: context)
    }
    
    func changeCategoryForTracker(trackerID: UUID, to newCategoryName: String) {
        
        let fetchTrackerRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchTrackerRequest.predicate = NSPredicate(format: "id == %@", trackerID as CVarArg)
        
        let fetchNewCategoryRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        fetchNewCategoryRequest.predicate = NSPredicate(format: "title == %@", newCategoryName)
        
        let fetchAllCategoriesRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        
        do {
            
            if let trackerToMove = try context.fetch(fetchTrackerRequest).first {
                
                let allCategories = try context.fetch(fetchAllCategoriesRequest)
                for category in allCategories {
                    if let trackers = category.trackers?.allObjects as? [TrackerCoreData],
                       trackers.contains(trackerToMove) {
                        category.removeFromTrackers(trackerToMove)
                    }
                }
                
                if let newCategory = try context.fetch(fetchNewCategoryRequest).first {
                    
                    newCategory.addToTrackers(trackerToMove)
                    
                    appDelegate.saveContext(context: context)
                } else {
                    print("New category not found, please create it first.")
                }
            } else {
                print("Tracker not found.")
            }
            
        } catch {
            print("Failed to change category for tracker: \(error.localizedDescription)")
        }
    }
    
    func fetchCategory(forTracker id: UUID) -> TrackerCategory? {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        
        do {
            let categoriesCoreData = try context.fetch(fetchRequest)
            
            for categoryCoreData in categoriesCoreData {
                if let trackers = categoryCoreData.trackers?.allObjects as? [TrackerCoreData],
                   trackers.contains(where: { $0.id == id }) {
                    let trackers = trackers.compactMap { trackerCoreData -> Tracker? in
                        guard let trackerID = trackerCoreData.id,
                              let trackerTitle = trackerCoreData.title,
                              let colorData = trackerCoreData.color,
                              let color = UIColor.color(withData: colorData),
                              let emoji = trackerCoreData.emoji,
                              let isPinned = trackerCoreData.isPinned,
                              let scheduleData = trackerCoreData.schedule,
                              let schedule = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: scheduleData) as? [Bool] else {
                            return nil
                        }
                        return Tracker(
                            id: trackerID,
                            title: trackerTitle,
                            color: color,
                            emoji: emoji,
                            isPinned: isPinned.boolValue,
                            schedule: schedule
                        )
                    }
                    
                    guard let title = categoryCoreData.title else { return nil }
                    
                    return TrackerCategory(title: title, trackers: trackers)
                }
            }
        } catch {
            print("Failed to fetch category for tracker: \(error)")
            return nil
        }
        return nil
    }
    
    func fetchAllCategories() -> [TrackerCategory] {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        
        do {
            let categoriesCoreData = try context.fetch(fetchRequest)
            return categoriesCoreData.compactMap { categoryCoreData in
                guard let title = categoryCoreData.title else {
                    print("Failed to unwrap category title")
                    return nil
                }
                
                let trackers = (categoryCoreData.trackers?.allObjects as? [TrackerCoreData])?.compactMap { trackerCoreData -> Tracker? in
                    guard let trackerID = trackerCoreData.id,
                          let trackerTitle = trackerCoreData.title,
                          let colorData = trackerCoreData.color,
                          let color = UIColor.color(withData: colorData),
                          let emoji = trackerCoreData.emoji,
                          let isPinned = trackerCoreData.isPinned,
                          let scheduleData = trackerCoreData.schedule,
                          let schedule = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: scheduleData) as? [Bool] else {
                        print("Failed to unwrap TrackerCoreData properties")
                        return nil
                    }
                    
                    return Tracker(
                        id: trackerID,
                        title: trackerTitle,
                        color: color,
                        emoji: emoji,
                        isPinned: isPinned.boolValue,
                        schedule: schedule
                    )
                } ?? []
                
                return TrackerCategory(title: title, trackers: trackers)
            }
        } catch {
            print("Failed to fetch categories: \(error)")
            return []
        }
    }
    
}
