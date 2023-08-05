import Foundation

// MARK: - Protocol

@objc protocol CategoriesViewModelDelegate: AnyObject {
    @objc optional func reloadData()
    @objc func reloadDataCategories(_ array: [String])
}

// MARK: - CategoriesViewModel

final class CategoriesViewModel {
    weak var delegate: CategoriesViewModelDelegate?
    private var categories: TrackerCategoryStore!
    
    init(delegate: CategoriesViewModelDelegate? = nil) {
        self.delegate = delegate
    }
}

// MARK: - Input 
extension CategoriesViewModel {
    func viewDidLoad() {
        updateCategories()
    }
    
    func setCategory(category: String?) {
        guard let category = category else { return }
        do {
            try categories.addCategory(category: category)
        } catch let error {
            print(error.localizedDescription)
        }
        
        updateCategories()
    }
}

// MARK: - Output
extension CategoriesViewModel {
    
    private func reloadData() {
        delegate?.reloadData?()
    }
    
    private func updateCategories() {
        categories = TrackerCategoryStore()
        let array = categories.getCategoriesNames()
        delegate?.reloadDataCategories(array)
    }
}
