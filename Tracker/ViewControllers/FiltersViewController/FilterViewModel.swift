final class FilterViewModel {
    
    //MARK: - Public Properties
    
    var filtersNames: [String] = {
        return FiltersNames.allCases.map { $0.rawValue }
    }()
    
}
