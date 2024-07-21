import UIKit
import CoreData

final class TrackerStore: NSObject, NSFetchedResultsControllerDelegate {

    private let appDelegate = AppDelegate()
    private var context: NSManagedObjectContext
    private var categoryFetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>!
    private var trackerFetchedResultsController: NSFetchedResultsController<TrackerCoreData>!
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        setupFetchedResultsControllers()
    }
    
    func fetchAllTrackers() -> [TrackerCoreData] {
         let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
         do {
             return try context.fetch(fetchRequest)
         } catch {
             print("Failed to fetch trackers: \(error)")
             return []
         }
    }
    
    func loadInitialData(factory: TrackersFactory) {
          updateTrackersStorage(factory: factory)
      }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
         updateTrackersStorage(factory: TrackersFactory.shared)
         NotificationCenter.default.post(name: TrackersFactory.trackersForShowingUpdatedNotification, object: nil)
     }
     
    func addTracker(tracker: Tracker, to category: TrackerCategoryCoreData){
        
        let newTracker = TrackerCoreData(context: context)
        newTracker.id = tracker.id
        newTracker.title = tracker.title
        newTracker.color = tracker.color.encodeColor()
        newTracker.emoji = tracker.emoji
        newTracker.schedule = tracker.schedule.encode()
        newTracker.category = category
        appDelegate.saveContext(context: context)
        
    }
    
    func addCategory(title: String) {
           let newCategory = TrackerCategoryCoreData(context: context)
           newCategory.title = title
        appDelegate.saveContext(context: context)
       }
    
    func fetchCategory(withTitle title: String) -> TrackerCategoryCoreData? {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("Failed to fetch category: \(error)")
            return nil
        }
    }
    
    func fetchTracker(id: UUID) -> Tracker? {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            if let trackerCoreData = try context.fetch(fetchRequest).first {
                return Tracker(
                    id: trackerCoreData.id ?? UUID(),
                    title: trackerCoreData.title ?? "Unknown title",
                    color: UIColor.color(withData: trackerCoreData.color!) ?? .clear,
                    emoji: trackerCoreData.emoji ?? "",
                    schedule: trackerCoreData.schedule?.decodeSchedule()! ?? []
                )
            } else {
                return nil
            }
        } catch {
            print("Failed to fetch tracker: \(error)")
                        return nil
        }
    }
    
    private func setupFetchedResultsControllers() {
        let categoryFetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        categoryFetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        categoryFetchedResultsController = NSFetchedResultsController(fetchRequest: categoryFetchRequest,
                                                                      managedObjectContext: context,
                                                                      sectionNameKeyPath: nil,
                                                                      cacheName: nil)
        categoryFetchedResultsController.delegate = self
        
        let trackerFetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        trackerFetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        trackerFetchedResultsController = NSFetchedResultsController(fetchRequest: trackerFetchRequest,
                                                                     managedObjectContext: context,
                                                                     sectionNameKeyPath: nil,
                                                                     cacheName: nil)
        trackerFetchedResultsController.delegate = self
        
        do {
            try categoryFetchedResultsController.performFetch()
            try trackerFetchedResultsController.performFetch()
        } catch {
            print("Failed to fetch data: \(error)")
        }
    }
    
    private func updateTrackersStorage(factory: TrackersFactory) {
           factory.trackersStorage.removeAll()
           
           guard let categories = categoryFetchedResultsController.fetchedObjects else { return }
           
           for category in categories {
               let trackers = category.trackers?.allObjects as? [TrackerCoreData] ?? []
               let trackerModels = trackers.map { trackerCoreData -> Tracker in
                   return Tracker(id: trackerCoreData.id!,
                                  title: trackerCoreData.title!,
                                  color: UIColor.color(withData: trackerCoreData.color!) ?? .clear,
                                  emoji: trackerCoreData.emoji!,
                                  schedule: (try! NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, NSNumber.self], from: trackerCoreData.schedule!) as? [Bool])!)
               }
               factory.trackersStorage.append(TrackerCategory(title: category.title!, trackers: trackerModels))
           }
       }
    
}

extension UIColor {
    func encodeColor() -> Data {
        return try! NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
    }
}

extension Array where Element == Bool {
    func encode() -> Data {
        return try! NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
    }
}

extension UIColor {
    class func color(withData data: Data) -> UIColor? {
        return try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
    }
}

extension Data {
    func decodeSchedule() -> [Bool]? {
        return try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: self) as? [Bool]
    }
    
    func decodeColor() -> UIColor? {
           return try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: self)
       }
}

