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
