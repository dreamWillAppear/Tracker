import UIKit
import CoreData

final class TrackerCategoryStore {
    
    private let appDelegate = AppDelegate()
    private let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
    private var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func addCategory(_ category: TrackerCategory) {
        let categoryCoreData = TrackerCategoryCoreData(context: context)
        categoryCoreData.title = category.title
        appDelegate.saveContext(context: context)
    }
    
    func fetchCategory(withTitle title: String) -> TrackerCategoryCoreData? {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        
        do {
            let categories = try context.fetch(fetchRequest)
            return categories.first
        } catch {
            print("Failed to fetch category: \(error)")
            return nil
        }
    }
    
    func fetchAllCategories() -> [TrackerCategory] {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        
        do {
            let categoriesCoreData = try context.fetch(fetchRequest)
            return categoriesCoreData.map { categoryCoreData in
                let trackers = categoryCoreData.trackers?.allObjects as? [TrackerCoreData] ?? []
                let trackerModels = trackers.map { trackerCoreData in
                    Tracker(
                        id: trackerCoreData.id!,
                        title: trackerCoreData.title!,
                        color: UIColor.color(withData: trackerCoreData.color!)!,
                        emoji: trackerCoreData.emoji!,
                        schedule: try! NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: trackerCoreData.schedule!) as! [Bool]
                    )
                }
                return TrackerCategory(title: categoryCoreData.title!, trackers: trackerModels)
            }
        } catch {
            print("Failed to fetch categories: \(error)")
            return []
        }
    }
    
}
