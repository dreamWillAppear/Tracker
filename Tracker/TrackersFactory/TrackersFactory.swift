import UIKit

final class TrackersFactory {
    
    // MARK: - Public Properties
    
    static let shared = TrackersFactory()
    static let trackersUpdatedNotification = Notification.Name("trackersUpdatedNotification")
    
    // MARK: - Private Properties
    
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


