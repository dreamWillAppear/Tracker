final class CategorySelectViewModel {
    
    //MARK: - Public Properties
    
    var categories: [TrackerCategory] = []
    
    var categoriesUpdated: (() -> Void)?
    
    //MARK: - Private Properties
    
    private let trackerCategoryStore = TrackerCategoryStore(context: TrackersFactory.shared.context)
    
    //MARK: - Public Methods
    
    init() {
        fetchCategories()
    }
    
    func addCategory(name: String) {
        trackerCategoryStore.addCategory(name: name)
    }
    
    func fetchCategories() {
        categories = trackerCategoryStore.fetchAllCategories()
        categoriesUpdated?()
    }
    
    
    
}
