final class FilterViewModel {
    
    private let factory = TrackersFactory.shared
    
    var filtersNames: [String] = {
        return FiltersNames.allCases.map { $0.rawValue }
    }()
    
}
