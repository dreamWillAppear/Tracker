import UIKit
import CoreData

final class TrackerRecordStore {
    
    //MARK: - Private Properties
    
    private let appDelegate = AppDelegate()
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    //MARK: - Public Properties
    
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
    
    func deleteRecords(for trackerID: UUID) {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "trackerID == %@", trackerID as CVarArg)
        
        do {
            let records = try context.fetch(fetchRequest)
            for record in records {
                context.delete(record)
            }
            appDelegate.saveContext(context: context)
        } catch {
            print("Failed to delete records for trackerID \(trackerID): \(error)")
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
    
    func getRecordsCount() -> Int {
        let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        
        do {
            return try context.count(for: request)
        } catch {
            print("Failed to count records: \(error)")
            return 0
        }
    }
    
    func getAllDatesWithRecords() -> [Date] {
        var dates = [Date]()
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        fetchRequest.propertiesToFetch = ["date"]
        fetchRequest.returnsDistinctResults = true
        
        do {
            let records = try context.fetch(fetchRequest)
            dates = records.compactMap { $0.date }
        } catch {
            print("Failed to fetch dates with records: \(error)")
            return dates
        }
        
        return dates
    }
    
    func getCompletedTrackersCount(on date: Date) -> Int {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date == %@", date as CVarArg)
        
        do {
            let records = try context.fetch(fetchRequest)
            return records.count
        } catch {
            print("Failed to fetch completed trackers for date: \(error)")
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
