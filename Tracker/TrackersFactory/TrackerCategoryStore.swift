import UIKit
import CoreData

final class TrackerCategoryStore {
    
    private let appDelegate = AppDelegate()
    private lazy var context = appDelegate.context
    
    func fetchAllRecords() -> [TrackerCategoryCoreData] {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch records - \(error.localizedDescription)")
            return []
        }
    }
    
    func addCategory(title: String) {
        let category = TrackerCategoryCoreData(context: context)
        category.title = title
        appDelegate.saveContext()
    }
    
}
