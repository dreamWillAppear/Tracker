import UIKit

final class TrackersFactory {
    
    // MARK: - Public Properties
    
    static let shared = TrackersFactory()
    static let trackersForShowingUpdatedNotification = Notification.Name("trackersForShowingUpdatedNotification")
    static let scheduleUpdatedNotification = Notification.Name("scheduleUpdatedNotification")
    
    lazy var context = appDelegate.persistentContainer.viewContext
    
    var selectedEmoji = ""
    var selectedColor = UIColor()
    var isPinned = false
    var weekdayIndex = TrackerCalendar.currentDayWeekIndex
    
    var pinnedTrackers: [Tracker] = []
    
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
    
    private let appDelegate = AppDelegate()
    private lazy var categoryStore = TrackerCategoryStore(context: context)
    private lazy var trackerStore = TrackerStore(context: context)
    private lazy var trackerRecordStore = TrackerRecordStore(context: context)
    
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
        if let existingCategory = categoryStore.fetchAllCategories().first(where: { $0.title == category }) {
            trackerStore.addTracker(tracker, to: existingCategory)
        } else {
            let newCategory = TrackerCategory(title: category, trackers: [])
            categoryStore.addCategory(newCategory)
            trackerStore.addTracker(tracker, to: newCategory)
        }
    }
    
    func deleteTrackerFromStorage(UUID: UUID) {
        trackerStore.deleteTracker(id: UUID)
    }
    
    func getPinnedAndUnpinnedTrackers(forDayWithIndex index: Int) -> ([Tracker], [Tracker]) {
        let trackers = filterTrackers(in: trackersStorage, forDayWithIndex: index)
            .flatMap { $0.trackers }
        let pinned = trackers.filter { $0.isPinned }
        let unpinned = trackers.filter { !$0.isPinned }
        return (pinned, unpinned)
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
    
    func getDayCounterLabel(for tracker: Tracker) -> String {
        let daysCount = getRecordsCount(for: tracker)
        var counterLabel = ""
        
        let lastTwoDigits = daysCount % 100
        let lastDigit = daysCount % 10
        
        if (11...14).contains(lastTwoDigits) {
            counterLabel = "\(daysCount) дней"
        } else {
            switch lastDigit {
            case 1:
                counterLabel = "\(daysCount) день"
            case 2, 3, 4:
                counterLabel = "\(daysCount) дня"
            default:
                counterLabel = "\(daysCount) дней"
            }
        }
        return counterLabel
    }
    
    func editTracker(id: UUID, newTitle: String, newColor: UIColor, newEmoji: String, isPinned: Bool, newSchedule: [Bool], oldCategoryName: String, newCategoryName: String) {
        trackerStore.updateTracker(
            id: id,
            newTitle: newTitle,
            newColor: newColor,
            newEmoji: newEmoji,
            newSchedule: newSchedule, 
            isPinned: isPinned
        )
        
        categoryStore.changeCategoryForTracker(trackerID: id, to: newCategoryName)
    }
    
    func updateTrackersForShowing() {
        let (pinned, unpinned) = getPinnedAndUnpinnedTrackers(forDayWithIndex: weekdayIndex)
        pinnedTrackers = pinned
        trackersForShowing = filterTrackers(in: trackersStorage, forDayWithIndex: weekdayIndex)
    }

    func markTrackerAsCompleted(trackerID: UUID, on date: Date) {
        let record = TrackerRecord(trackerID: trackerID, date: date)
        trackerRecordStore.addRecord(record)
    }
    
    func unmarkTrackerAsCompleted(trackerID: UUID, on date: Date) {
        let record = TrackerRecord(trackerID: trackerID, date: date)
        trackerRecordStore.removeRecord(record)
    }
    
    func todayAlreadyRecorded(trackerID: UUID) -> Bool {
        let today = Date()
        return trackerRecordStore.checkRecord(trackerID: trackerID, on: today)
    }
    
    func isTrackerCompleted(trackerID: UUID, on date: Date) -> Bool {
        return trackerRecordStore.checkRecord(trackerID: trackerID, on: date)
    }
    
    func getRecordsCount(for tracker: Tracker) -> Int {
        trackerRecordStore.getRecordsCount(for: tracker.id)
    }
    
    func getCategory(forTracker id: UUID) -> TrackerCategory? {
        categoryStore.fetchCategory(forTracker: id)
    }
}


