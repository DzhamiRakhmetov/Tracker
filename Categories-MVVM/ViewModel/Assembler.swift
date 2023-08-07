import UIKit

class Assembler {
    
    static func makeCategoriesViewController() -> CategoriesViewController {
        
        let categoryStore = TrackerCategoryStore()
        let viewModel = CategoriesViewModel(categoryStore: categoryStore)
        let vc = CategoriesViewController(viewModel: viewModel)
        return vc
    }
}
