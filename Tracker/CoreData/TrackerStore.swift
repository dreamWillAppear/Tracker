import UIKit
import CoreData

final class TrackerStore: NSObject, NSFetchedResultsControllerDelegate {
    
    private let appDelegate = AppDelegate()
    private var context: NSManagedObjectContext
    private var categoryFetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>?
    private var trackerFetchedResultsController: NSFetchedResultsController<TrackerCoreData>?
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        setupFetchedResultsControllers()
    }
    
    func loadInitialData(factory: TrackersFactory) {
        updateTrackersStorage(factory: factory)
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
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateTrackersStorage(factory: TrackersFactory.shared)
        NotificationCenter.default.post(name: TrackersFactory.trackersForShowingUpdatedNotification, object: nil)
    }
    
    func addTracker(_ tracker: Tracker, to category: TrackerCategory) {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.id = tracker.id
        trackerCoreData.title = tracker.title
        trackerCoreData.color = tracker.color.encodeColor()
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.schedule = tracker.schedule.encode()
        
        if let categoryCoreData = fetchCategoryCoreData(withTitle: category.title) {
            trackerCoreData.category = categoryCoreData
        }
        
        appDelegate.saveContext(context: context)
    }
    
    func addCategory(title: String) {
        let newCategory = TrackerCategoryCoreData(context: context)
        newCategory.title = title
        appDelegate.saveContext(context: context)
    }
    
    func fetchTracker(by id: UUID) -> Tracker? {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            if let trackerCoreData = try context.fetch(fetchRequest).first {
                return Tracker(
                    id: trackerCoreData.id!,
                    title: trackerCoreData.title!,
                    color: UIColor.color(withData: trackerCoreData.color!)!,
                    emoji: trackerCoreData.emoji!,
                    schedule: try! NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: trackerCoreData.schedule!) as! [Bool]
                )
            } else {
                return nil
            }
        } catch {
            print("Failed to fetch tracker: \(error)")
            return nil
        }
    }
    
    private func fetchCategoryCoreData(withTitle title: String) -> TrackerCategoryCoreData? {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("Failed to fetch category: \(error)")
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
        categoryFetchedResultsController?.delegate = self
        
        let trackerFetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        trackerFetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        trackerFetchedResultsController = NSFetchedResultsController(fetchRequest: trackerFetchRequest,
                                                                     managedObjectContext: context,
                                                                     sectionNameKeyPath: nil,
                                                                     cacheName: nil)
        trackerFetchedResultsController?.delegate = self
        
        do {
            try categoryFetchedResultsController?.performFetch()
            try trackerFetchedResultsController?.performFetch()
        } catch {
            print("Failed to fetch data: \(error)")
        }
    }
    
    private func updateTrackersStorage(factory: TrackersFactory) {
        factory.trackersStorage.removeAll()
        
        guard let categories = categoryFetchedResultsController?.fetchedObjects else { return }
        
        for category in categories {
            if let trackers = category.trackers?.allObjects as? [TrackerCoreData] {
                let trackerModels = trackers.compactMap { trackerCoreData -> Tracker? in
                    guard
                        let id = trackerCoreData.id,
                        let title = trackerCoreData.title,
                        let colorData = trackerCoreData.color,
                        let emoji = trackerCoreData.emoji,
                        let scheduleData = trackerCoreData.schedule,
                        let schedule = try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, NSNumber.self], from: scheduleData) as? [Bool]
                    else {
                        return nil
                    }
                    
                    let color = UIColor.color(withData: colorData) ?? .clear
                    
                    return Tracker(id: id, title: title, color: color, emoji: emoji, schedule: schedule)
                }
                
                if let categoryTitle = category.title {
                    factory.trackersStorage.append(TrackerCategory(title: categoryTitle, trackers: trackerModels))
                }
            }
        }
    }
}

extension UIColor {
    func encodeColor() -> Data {
        do {
            return try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
        } catch {
            fatalError("Failed to encode UIColor: \(error)")
        }
    }
    
    class func color(withData data: Data) -> UIColor? {
        do {
            return try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
        } catch {
            print("Failed to decode UIColor: \(error)")
            return nil
        }
    }
}

extension Array where Element == Bool {
    func encode() -> Data? {
        do {
            return try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
        } catch {
            print("Failed to encode array: \(error)")
            return nil
        }
    }
    
    static func decode(from data: Data) -> [Bool]? {
        do {
            return try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, NSNumber.self], from: data) as? [Bool]
        } catch {
            print("Failed to decode array: \(error)")
            return nil
        }
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

