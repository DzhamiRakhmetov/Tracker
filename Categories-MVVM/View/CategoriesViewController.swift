import UIKit

// MARK: - Protocol
protocol CategoriesViewControllerDelegate: AnyObject {
    func selectCategory(_ string: String)
}

// MARK: - CategoriesViewController 

final class CategoriesViewController: UIViewController {
    weak var delegate: CategoriesViewControllerDelegate?
    
    private var viewModel: CategoriesViewModelProtocol
    private lazy var categoryView: UICategoryListView = UICategoryListView()
    
    init(viewModel: CategoriesViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = categoryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        view.backgroundColor = .custom.white
        setUpConstraints()
        viewModel.viewDidLoad()
    }
    
    private func setUpConstraints() {
        categoryView.translatesAutoresizingMaskIntoConstraints = false
        categoryView.didSelectCategory = doneButtonClicked
        categoryView.delegate = self
        
        NSLayoutConstraint.activate([
            categoryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            categoryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            categoryView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoryView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    func doneButtonClicked() -> Void {
        let newCategoryViewController = NewCategoryViewController()
        newCategoryViewController.delegate = self
        present(newCategoryViewController, animated: true)
    }
}

// MARK: - Extensions

extension CategoriesViewController: NewCategoryViewControllerDelegate {
    func setCategory(category: String?) {
        viewModel.setCategory(category: category)
    }
}

extension CategoriesViewController: CategoriesViewModelDelegate {
    func reloadDataCategories(_ array: [String]) {
        categoryView.categories = array
    }
}

extension CategoriesViewController: UICategoryListViewDelegate {
    func didSelect(_ category: String) {
        delegate?.selectCategory(category)
        dismiss(animated: true) {}
    }
}
