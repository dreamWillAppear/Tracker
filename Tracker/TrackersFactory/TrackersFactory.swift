import UIKit

final class TrackersFactory {
    
    // MARK: - Public Properties
    
    static let shared = TrackersFactory()
    static let trackersForShowingUpdatedNotification = Notification.Name("trackersForShowingUpdatedNotification")

    var weekdayIndex = TrackerCalendar.currentDayweekIndex
    
    var schedule = Array(repeating: false, count: Weekday.allCases.count)
    
    var trackersForShowing: [TrackerCategory] = [] {
        didSet {
            NotificationCenter.default.post(name: TrackersFactory.trackersForShowingUpdatedNotification, object: nil)
            print("в trackersForShowing \(trackersForShowing.count) категорий для показа")
        }
    }
    
    var trackersStorage: [TrackerCategory] = [] {
        didSet{
            //приводим к исходному schedule после добавления трекера в хранилище
            schedule = Array(repeating: false, count: Weekday.allCases.count)
            print("в trackersStorage \(trackersStorage.count) категорий")
        }
    }
    
    // MARK: - Initializers
    
    private  init() {}
    
    // MARK: - Public Methods
    
    func addToStorage(tracker: Tracker, for category: String) {
        if let index = trackersStorage.enumerated().first(where: { $0.element.title == category })?.offset {
            trackersStorage[index].trackers.append(tracker)
        } else {
            trackersStorage.append(TrackerCategory(title: category, trackers: [tracker]))
        }
    }
    
    
    func filterTrackers(in categoriesArray: [TrackerCategory],forDayWithIndex weekdayIndex: Int) -> [TrackerCategory] {
        var categoriesForShowing: [TrackerCategory] = []
        for category in categoriesArray {
            for tracker in category.trackers {
                
                if tracker.schedule[weekdayIndex] == true {
                    if let categoryIndex = categoriesForShowing.enumerated().first(where: { $0.element.title == category.title })?.offset {
                        categoriesForShowing[categoryIndex].trackers.append(tracker)
                    } else {
                        categoriesForShowing.append(TrackerCategory(title: category.title, trackers: [tracker]))
                    }
                }
                
            }
        }
        return categoriesForShowing
    }
    
    func updateTrackersForShowing() {
        trackersForShowing = filterTrackers(in: trackersStorage, forDayWithIndex: weekdayIndex)
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


