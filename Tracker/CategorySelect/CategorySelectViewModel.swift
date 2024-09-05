import Combine

final class CategorySelectViewModel {
    
    @Published var categories: [TrackerCategory] = []
    
    private let trackerCategoryStore = TrackerCategoryStore(context: TrackersFactory.shared.context)
    
    var categoriesUpdated: (() -> Void)?
    
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
