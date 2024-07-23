import UIKit
import CoreData

final class TrackerRecordStore {
    
    private let appDelegate = AppDelegate()
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchAllRecords() -> [TrackerRecordCoreData] {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch records - \(error.localizedDescription)")
            return []
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
        let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "trackerID == %@ AND date == %@", trackerID as CVarArg, date as CVarArg)
        
        do {
            let records = try context.count(for: request)
            return records > 0
        } catch {
            return false
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
    
}
