import UIKit
import CoreData

final class TrackerRecordStore {
    
    private let appDelegate = AppDelegate()
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func addRecord(_ record: TrackerRecord) {
        let recordCoreData = TrackerRecordCoreData(context: context)
        recordCoreData.trackerID = record.trackerID
        recordCoreData.date = record.date
        appDelegate.saveContext(context: context)
    }
    
    func removeRecord(_ record: TrackerRecord) {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "trackerID == %@ AND date == %@", record.trackerID as CVarArg, record.date as CVarArg)
        
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
    
    func markTrackerAsCompleted(trackerID: UUID, on date: Date) {
        let record = TrackerRecordCoreData(context: context)
        record.trackerID = trackerID
        record.date = date
        appDelegate.saveContext(context: context)
    }
    
    func unmarkTrackerAsCompleted(trackerID: UUID, on date: Date) {
        let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "trackerID == %@ AND date == %@", trackerID as CVarArg, date as CVarArg)
        
        do {
            let records = try context.fetch(request)
            records.forEach { record in
                context.delete(record)
            }
            appDelegate.saveContext(context: context)
        } catch {
            print("TrackerRecordStore - Failed to fetch record \(error.localizedDescription)")
        }
    }
    
    func checkRecord(trackerID: UUID, on date: Date) -> Bool {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "trackerID == %@ AND date == %@", trackerID as CVarArg, date as CVarArg)
        
        do {
            let records = try context.fetch(fetchRequest)
            return !records.isEmpty
        } catch {
            print("Failed to fetch record: \(error)")
            return false
        }
    }
    
}
