import UIKit

struct Tracker {
    let id: UUID
    let title: String
    let color: UIColor
    let emoji: String
    let schedule: [Bool]
}

struct TrackerCategory {
    let title: String
    var trackers: [Tracker]
    
}

struct TrackerRecord {
    let trackerID: UUID
    let date: String
}
