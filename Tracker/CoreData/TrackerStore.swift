import UIKit
import CoreData

final class TrackerStore {
    
    private let appDelegate = AppDelegate()
    
    private lazy var context = appDelegate.context
    
    func fetchAllTrackers() -> [TrackerCoreData] {
         let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
         do {
             return try context.fetch(fetchRequest)
         } catch {
             print("Failed to fetch trackers: \(error)")
             return []
         }
    }
    
    func addTracker(id: UUID, title: String, color: UIColor, emoji: String, schedule: [Bool], category: TrackerCategoryCoreData) {
        let tracker = TrackerCoreData(context: context)
        tracker.id = id
        tracker.title = title
        tracker.color = color.encodeColor()
        tracker.emoji = emoji
        tracker.schedule = schedule.encode()
        tracker.category = category
        appDelegate.saveContext()
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

extension Data {
    func decodeSchedule() -> [Bool]? {
        return try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: self) as? [Bool]
    }
    
    func decodeColor() -> UIColor? {
           return try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: self)
       }
}

