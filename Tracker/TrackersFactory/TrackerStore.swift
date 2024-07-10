import UIKit
import CoreData

final class TrackerStore {
    private let context: NSManagedObjectContext
    
    convenience init?() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let context = appDelegate.persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
}
