import UIKit
import CoreData

final class TrackerCategoryStore {
    
    private let appDelegate = AppDelegate()
    private let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
    private var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchAllRecords() -> [TrackerCategoryCoreData] {
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch records - \(error.localizedDescription)")
            return []
        }
    }
    
    func fetchAllCategories() -> [String] {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        
        do {
            let categories = try context.fetch(fetchRequest)
            return categories.compactMap { $0.title }
        } catch {
            print("Failed to fetch categories: \(error)")
            return []
        }
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
    
    func addCategory(title: String) {
        if fetchCategory(withTitle: title) == nil {
            let newCategory = TrackerCategoryCoreData(context: context)
            newCategory.title = title
            appDelegate.saveContext(context: context)
            return
        }
    }
    
}
