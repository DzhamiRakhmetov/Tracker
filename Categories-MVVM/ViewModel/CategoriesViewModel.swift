import Foundation

// MARK: - Protocol

protocol CategoriesViewModelDelegate: AnyObject {
    func reloadDataCategories(_ array: [String])
}

// MARK: - CategoriesViewModel

final class CategoriesViewModel {
    weak var delegate: CategoriesViewModelDelegate?
    private let categoryStore: TrackerCategoryStoreProtocol
    
    init(categoryStore: TrackerCategoryStoreProtocol) {
        self.categoryStore = categoryStore
    }
}

// MARK: - Input 
extension CategoriesViewModel: CategoriesViewModelProtocol {
    func viewDidLoad() {
        updateCategories()
    }
    
    func setCategory(category: String?) {
        guard let category = category else { return }
        do {
            try categoryStore.addCategory(category: category)
        } catch let error {
            print(error.localizedDescription)
        }
        updateCategories()
    }
    
    func deleteCategory(at indexPath: IndexPath) {
        do {
            try categoryStore.deleteCategory(at: indexPath)
        } catch let error {
            print(error.localizedDescription)
        }
        updateCategories()
    }
}

// MARK: - Output
extension CategoriesViewModel {
    
    private func updateCategories() {
        let array = categoryStore.getCategoriesNames()
        delegate?.reloadDataCategories(array)
    }
}
