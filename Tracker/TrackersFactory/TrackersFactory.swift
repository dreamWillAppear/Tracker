import UIKit

final class TrackersFactory {
    
    // MARK: - Public Properties
    
    static let shared = TrackersFactory()
    static let trackersForShowingUpdatedNotification = Notification.Name("trackersForShowingUpdatedNotification")
    static let scheduleUpdatedNotification = Notification.Name("scheduleUpdatedNotification")
    
    var selectedEmoji = ""
    var selectedColor = UIColor()
    
    var weekdayIndex = TrackerCalendar.currentDayWeekIndex
    
    var schedule = Array(repeating: false, count: WeekDay.allCases.count) {
        didSet {
            NotificationCenter.default.post(name: TrackersFactory.scheduleUpdatedNotification, object: nil)
        }
    }
    
    var trackersForShowing: [TrackerCategory] = [] {
        didSet {
            NotificationCenter.default.post(name: TrackersFactory.trackersForShowingUpdatedNotification, object: nil)
        }
    }
    
    var trackersStorage: [TrackerCategory] = [] {
        didSet{
            //приводим к исходному schedule после добавления трекера в хранилище
            schedule = Array(repeating: false, count: WeekDay.allCases.count)
            updateTrackersForShowing()
        }
    }
    
    var completedTrackers: [TrackerRecord] = []
    
    private let appDelegate = AppDelegate()
    private lazy var context = appDelegate.persistentContainer.viewContext
    private lazy var categoryStore = TrackerCategoryStore(context: context)
    private lazy var trackerStore = TrackerStore(context: context)
    
    // MARK: - Initializers
    
    private  init() {
        getInitialData()
    }
    
    // MARK: - Public Methods
    
    func eraseAllDataFromBase() {
        appDelegate.clearAllData(context: context)
    }
    
    func getInitialData() {
        trackerStore.loadInitialData(factory: self)
    }
    
    func addToStorage(tracker: Tracker, for category: String) {
        
        if let categoryEntity = trackerStore.fetchCategory(withTitle: category) {
                   trackerStore.addTracker(tracker: tracker, to: categoryEntity)
               } else {
                   trackerStore.addCategory(title: category)
                   guard let newCategory = trackerStore.fetchCategory(withTitle: category) else { return }
                   trackerStore.addTracker(tracker: tracker, to: newCategory)
               }
    }
        
    func filterTrackers(in categoriesArray: [TrackerCategory], forDayWithIndex weekdayIndex: Int) -> [TrackerCategory] {
        var categoriesForShowing: [TrackerCategory] = []
        for category in trackersStorage {
            for tracker in category.trackers {
                if tracker.schedule[weekdayIndex] == true {
                    if let index = categoriesForShowing.enumerated().first(where:  { $0.element.title == category.title })?.offset {
                        let updatedCategory = categoriesForShowing[index]
                        var updatedTrackers = updatedCategory.trackers
                        updatedTrackers.append(tracker)
                        let newCategory = TrackerCategory(title: category.title, trackers: updatedTrackers)
                        categoriesForShowing[index] = newCategory
                    } else {
                        let newCategory = TrackerCategory(title: category.title, trackers: [tracker])
                        categoriesForShowing.append(newCategory)
                    }
                }
            }
        }
        return categoriesForShowing
    }
    
    func filterTrackers(in categoriesArray: [TrackerCategory], by name: String) -> [TrackerCategory] {
        var categoriesForShowing: [TrackerCategory] = []
        for category in categoriesArray {
            for tracker in category.trackers {
                let trackerName = tracker.title.lowercased()
                let searchText = name.lowercased()
                if trackerName.contains(searchText) {
                    if let categoryIndex = categoriesForShowing.enumerated().first(where: { $0.element.title == category.title })?.offset {
                        let updatedCategory = categoriesForShowing[categoryIndex]
                        var updatedTrackers = updatedCategory.trackers
                        updatedTrackers.append(tracker)
                        categoriesForShowing[categoryIndex] = updatedCategory
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
    
    func markTrackerAsCompleted(trackerID: UUID, on date: Date) {
        let record = TrackerRecord(trackerID: trackerID, date: date)
        if !completedTrackers.contains(where: { $0.trackerID == trackerID && $0.date == date }) {
            completedTrackers.append(record)
        }
    }
    
    func unmarkTrackerAsCompleted(trackerID: UUID, on date: Date) {
        if let index = completedTrackers.firstIndex(where: { $0.trackerID == trackerID && $0.date == date } ) {
            completedTrackers.remove(at: index)
        }
    }
    
    func isTrackerCompleted(trackerID: UUID, on date: Date) -> Bool {
        return completedTrackers.contains { $0.trackerID == trackerID && $0.date == date }
    }
    
    func getRecordsCount(for tracker: Tracker) -> Int {
        let trackerID = tracker.id
        return completedTrackers.filter( {$0.trackerID == trackerID} ).count
    }
    
    func randomColor() -> UIColor {
        UIColor(named: "Color selection \(String(Int.random(in: 1...18)))")!
    }
    
    
    func generateCatName() -> String {
        ["Важное", "Домашний уют", "Cамочувствие", "Мелочи"].randomElement()!
    }
}

