final class FilterViewModel {
    
    enum FiltersName: String, CaseIterable {
        case allTrackers = "Все трекеры"
        case todayTrackers = "Трекеры на сегодня"
        case completedTrackers = "Завершенные"
        case notCompletesTrackers = "Не завершенные"
    }
    
    var filtersName: [String] = {
        return FiltersName.allCases.map { $0.rawValue }
    }()
    
    
    
}
