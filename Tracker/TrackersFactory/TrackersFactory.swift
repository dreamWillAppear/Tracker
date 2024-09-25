import UIKit

final class TrackersFactory {
    
    // MARK: - Public Properties
    
    static let shared = TrackersFactory()
    static let trackersForShowingUpdatedNotification = Notification.Name("trackersForShowingUpdatedNotification")
    static let scheduleUpdatedNotification = Notification.Name("scheduleUpdatedNotification")
    
   
    
    lazy var context = appDelegate.persistentContainer.viewContext
    
    var trackerStorageUpdated: (() -> Void)?
    
    var selectedEmoji = ""
    var selectedColor = UIColor()
    var isPinned = false
    var weekdayIndex = TrackerCalendar.currentDayWeekIndex
    var selectedDate = Date()
    var currentFilterName = "Все трекеры"
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
            schedule = Array(repeating: false, count: WeekDay.allCases.count)  //приводим к исходному schedule после добавления трекера в хранилище
            trackerStorageUpdated?()
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
        trackerRecordStore.deleteRecords(for: UUID)
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
    
    func pinTracker(id: UUID, needPin: Bool) {
        trackerStore.pinTracker(id: id, needPin: needPin)
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
        
    func getAllRecordsCount() -> Int {
        trackerRecordStore.getRecordsCount()
    }
    
    func getCategory(forTracker id: UUID) -> TrackerCategory? {
        categoryStore.fetchCategory(forTracker: id)
    }
    
    func updateTrackersForShowing() {
        pinnedTrackers = getPinnedTrackers()
        trackersForShowing = getFilteredTrackers()
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
    
    func getCompletedTrackers() -> [TrackerCategory] {
      let allTrackers = filterTrackers(in: trackersStorage, forDayWithIndex: weekdayIndex)
      var completedCategories: [TrackerCategory] = []
      
      for category in allTrackers {
          let completedTrackers = category.trackers.filter { tracker in
              trackerRecordStore.checkRecord(trackerID: tracker.id, on: selectedDate)
          }
          
          if !completedTrackers.isEmpty {
              completedCategories.append(TrackerCategory(title: category.title, trackers: completedTrackers))
          }
      }
      
      return completedCategories
  }
    
    func getPerfectDays() -> [Date] {
        var perfectDays: [Date] = []
        let allTrackers = trackerStore.fetchAllTrackers()
        let allDatesWithRecords = trackerRecordStore.getAllDatesWithRecords()
        
        let calendar = Calendar.current
        
        for date in allDatesWithRecords {
            var isPerfectDay = true
            let weekday = calendar.component(.weekday, from: date)
            let dayOfWeekIndex = ((weekday + 5) % 7) // Используем ту же логику индексации, что и в datePicker
            
            for tracker in allTrackers {
                let schedule = tracker.schedule
                
                if dayOfWeekIndex >= 0 && dayOfWeekIndex < schedule.count && schedule[dayOfWeekIndex] {
                    let isCompleted = trackerRecordStore.checkRecord(trackerID: tracker.id, on: date)
                    if !isCompleted {
                        isPerfectDay = false
                        break
                    }
                }
            }
            
            if isPerfectDay {
                perfectDays.append(date)
            }
        }
        
        perfectDays = Array(Set(perfectDays)) // Удаляем дубли
        return perfectDays
    }

    func getLongestPerfectStreak(from perfectDays: [Date]) -> Int {
        
        let sortedDates = perfectDays.sorted()
        var maxCount = 0
        var currentCount = 0
        
        guard sortedDates.count > 0 else { return 0 }
        
        for i in 1..<sortedDates.count {
            let previousDate = sortedDates[i - 1]
            let currentDate = sortedDates[i]
            
            if Calendar.current.isDate(currentDate, inSameDayAs: previousDate.addingTimeInterval(86400)) {
                currentCount += 1
            } else {
                maxCount = max(maxCount, currentCount)
                currentCount = 0
            }
        }
        
        maxCount = max(maxCount, currentCount)
        
        guard maxCount > 0 else {  return 0 }
        
        return maxCount + 1
    }


    //MARK: - Private Methods
    
    //MARK: - Methods For Filter Button
    
    private  func  getFilteredTrackers() -> [TrackerCategory] {
        switch currentFilterName {
            case FiltersNames.allTrackers.rawValue:
                return getAllTrackers()
            case FiltersNames.todayTrackers.rawValue:
                return getTodayTrackers()
            case FiltersNames.completedTrackers.rawValue:
                return getCompletedTrackers()
            case FiltersNames.uncompletedTrackers.rawValue:
                return getUncompletedTrackers()
            default:
                return getAllTrackers()
        }
    }
    
    private  func getAllTrackers() -> [TrackerCategory] {
        filterTrackers(in: trackersStorage, forDayWithIndex: weekdayIndex)
    }
    
    private   func getTodayTrackers() -> [TrackerCategory] {
        filterTrackers(in: trackersStorage, forDayWithIndex: TrackerCalendar.currentDayWeekIndex)
    }
    
    private   func getUncompletedTrackers() -> [TrackerCategory] {
        let allTrackers = filterTrackers(in: trackersStorage, forDayWithIndex: weekdayIndex)
        var uncompletedCategories: [TrackerCategory] = []
        
        for category in allTrackers {
            let uncompletedTrackers = category.trackers.filter { tracker in
                !trackerRecordStore.checkRecord(trackerID: tracker.id, on: selectedDate)
            }
            
            if !uncompletedTrackers.isEmpty {
                uncompletedCategories.append(TrackerCategory(title: category.title, trackers: uncompletedTrackers))
            }
        }
        
        return uncompletedCategories
    }
    
    private func getPinnedTrackers() -> [Tracker]{
        var pinnedTrackers: [Tracker] = []
        let filteredStorage = getFilteredTrackers()
        filteredStorage.forEach { category in
            category.trackers.forEach { tracker in
                if tracker.isPinned {
                    pinnedTrackers.append(tracker)
                }
            }
        }
        
        return pinnedTrackers
    }
}


