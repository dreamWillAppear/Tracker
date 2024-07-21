import UIKit
import CoreData

final class TrackerRecordStore {
    
    private let appDelegate = AppDelegate()
    private lazy var context = appDelegate.context
    
    func fetchAllRecords() -> [TrackerRecordCoreData] {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch records - \(error.localizedDescription)")
            return []
        }
    }
    
    func addRecord(trackerID: UUID, date: Date) {
        let record = TrackerRecordCoreData(context: context)
        record.trackerID = trackerID
        record.date = date
        appDelegate.saveContext(context: context)
    }
    
}
