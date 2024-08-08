import UIKit
import CoreData

final class TrackerRecordStore {
    
    private let appDelegate = AppDelegate()
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func addRecord(_ record: TrackerRecord) {
        let calendar = TrackerCalendar.currentCalendar
        let startOfDay = calendar.startOfDay(for: record.date)
        let recordCoreData = TrackerRecordCoreData(context: context)
        recordCoreData.trackerID = record.trackerID
        recordCoreData.date = startOfDay
        appDelegate.saveContext(context: context)
    }
    
    func removeRecord(_ record: TrackerRecord) {
        let calendar = TrackerCalendar.currentCalendar
        let startOfDay = calendar.startOfDay(for: record.date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!.addingTimeInterval(-1)
        
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "trackerID == %@ AND date >= %@ AND date <= %@", record.trackerID as CVarArg, startOfDay as CVarArg, endOfDay as CVarArg)
        
        do {
            if let recordCoreData = try context.fetch(fetchRequest).first {
                context.delete(recordCoreData)
                appDelegate.saveContext(context: context)
            }
        } catch {
            print("Failed to fetch or delete record: \(error)")
        }
    }
    
    func getRecordsCount(for trackerID: UUID) -> Int {
        let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "trackerID == %@", trackerID as CVarArg)
        
        do {
            return try context.fetch(request).count
        } catch {
            print("TrackerRecordStore - Failed to get Records count: \(error.localizedDescription)")
            return 0
        }
    }
    
    func checkRecord(trackerID: UUID, on date: Date) -> Bool {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!.addingTimeInterval(-1)
        
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "trackerID == %@ AND date >= %@ AND date <= %@", trackerID as CVarArg, startOfDay as CVarArg, endOfDay as CVarArg)
        
        do {
            let records = try context.fetch(fetchRequest)
            return !records.isEmpty
        } catch {
            print("Failed to fetch record: \(error)")
            return false
        }
    }
    
}
