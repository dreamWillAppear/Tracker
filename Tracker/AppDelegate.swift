import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let window = UIWindow()
        window.rootViewController = TabBarController()
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Storage")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
    
    func clearAllData(context: NSManagedObjectContext) {
        let trackersRequest: NSFetchRequest<NSFetchRequestResult> = TrackerCoreData.fetchRequest()
        let categoriesRequest: NSFetchRequest<NSFetchRequestResult> = TrackerCategoryCoreData.fetchRequest()
        let trackerRecordRequest: NSFetchRequest<NSFetchRequestResult> = TrackerRecordCoreData.fetchRequest()
        
        do {
            guard let trackers = try context.fetch(trackersRequest) as? [TrackerCoreData],
                  let categories = try context.fetch(categoriesRequest) as? [TrackerCategoryCoreData],
                  let records = try context.fetch(trackerRecordRequest) as? [TrackerRecordCoreData] else {
                return
            }
            
            trackers.forEach { tracker in
                context.delete(tracker)
            }
            
            categories.forEach { category in
                context.delete(category)
            }
            
            records.forEach { record in
                context.delete(record)
            }
        
            try context.save()
        } catch {
            print("Failed to clean entities: \(error)")
        }
    }
    
    
}

