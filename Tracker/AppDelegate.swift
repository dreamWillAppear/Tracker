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
        
        do {
            if let trackers = try context.fetch(trackersRequest) as? [TrackerCoreData] {
                for tracker in trackers {
                    context.delete(tracker)
                }
            }
            
            if let categories = try context.fetch(categoriesRequest) as? [TrackerCategoryCoreData] {
                for category in categories {
                    context.delete(category)
                }
            }
            
            try context.save()
        } catch {
            print("Failed to delete entities: \(error)")
        }
    }
    
    
}

