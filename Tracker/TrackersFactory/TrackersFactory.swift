import UIKit

final class TrackersFactory {
    
    // MARK: - Public Properties
    
    static let shared = TrackersFactory()
    static let trackersUpdatedNotification = Notification.Name("trackersUpdatedNotification")
    let trackersViewController = TrackersViewController()
    
 
    var schedule = Array(repeating: false, count: Weekday.allCases.count)
    
    var categories: [TrackerCategory] = [] {
        didSet {
            NotificationCenter.default.post(name: TrackersFactory.trackersUpdatedNotification, object: nil)
        }
    }
    
    // MARK: - Initializers
    
    private  init() {}
    
    // MARK: - Public Methods
    
    func add(tracker: Tracker, in category: String) {
        if let index = categories.enumerated().first(where: { $0.element.title == category })?.offset {
            categories[index].trackers.append(tracker)
        } else {
            categories.append(TrackerCategory(title: category, trackers: [tracker]))
        }
        trackersViewController.updateCategoriesForShowing()
    }
    
    func filterTrackers(forDayWithIndex index: Int) -> [TrackerCategory] {
        var categoriesForShowing: [TrackerCategory] = []
        for category in categories {
                for tracker in category.trackers {
                    if tracker.schedule[trackersViewController.weekdayIndex] == true {
                        categoriesForShowing.append(category)
                    }
                }
            }
        return categoriesForShowing
    }
    
    func resetSchedule() {
        schedule = Array(repeating: false, count: Weekday.allCases.count)
    }
    
    func randomColor() -> UIColor {
        UIColor(named: "Color selection \(String(Int.random(in: 1...18)))")!
    }
    
    func randomEmoji() -> String {
    ["💎","🚀","🌙","🎁","⛄","🌊","⛵","🏀","🎱","💰","👄","🚲","🍉","💛","💚"].randomElement()!

    }
    
    func generateCatName() -> String {
        ["Важное", "Домашний уют", "Cамочувствие", "Мелочи"].randomElement()!
    }

    
}



// MARK: - Types

// MARK: - Constants

// MARK: - Public Properties

// MARK: - IBOutlet

// MARK: - Private Properties

// MARK: - Initializers

// MARK: - UIViewController(*)

// MARK: - Public Methods

// MARK: - IBAction

// MARK: - Private Methods


