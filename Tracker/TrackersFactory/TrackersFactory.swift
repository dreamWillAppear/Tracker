import Foundation

final class TrackersFactory {
    
    // MARK: - Public Properties
    
    static let shared = TrackersFactory()
    
    // MARK: - Private Properties
    
    private(set) var trackers: [Tracker] = []
    private(set) var categories: [TrackerCategory] = []
    
    // MARK: - Initializers
    
    private init() {}
    
    // MARK: - Public Methods
    
    func addCategory(withName: String) {
        let category = TrackerCategory(title: withName, trackers: [])
    }
    
    func addTracker() {
        
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


