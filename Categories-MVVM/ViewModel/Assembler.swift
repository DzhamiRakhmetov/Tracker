import UIKit

class Assembler {
    
    class func setCategoriesViewController() -> CategoriesViewController {
        let vc = CategoriesViewController()
        let viewModel = CategoriesViewModel(delegate: vc)
        vc.viewModel = viewModel
        return vc
    }
}
