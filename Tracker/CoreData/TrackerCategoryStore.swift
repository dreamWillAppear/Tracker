import UIKit
import CoreData

final class TrackerCategoryStore {
    
    private let appDelegate = AppDelegate()
    private lazy var context = appDelegate.context
    private let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
    
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
    
    func deleteAllRecords() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "TrackerCategoryCoreData")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            try context.save()
            print("All records deleted successfully.")
        } catch {
            print("Error deleting records: \(error)")
        }
    }
    
    func fetchCategory(withTitle title: String) -> String? {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "title == %@", title)
            
            do {
                let categories = try context.fetch(fetchRequest)
                return categories.first?.title
            } catch {
                print("Failed to fetch category: \(error)")
                return nil
            }
    
        }
    
    func addCategory(title: String) {
        if fetchCategory(withTitle: title) == nil {
            let newCategory = TrackerCategoryCoreData(context: context)
            newCategory.title = title
            appDelegate.saveContext()
            print(fetchAllCategories())
            return
        }
        print(fetchAllCategories())
    }
    
}
