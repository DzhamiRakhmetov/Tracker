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
    }
    
    func doneButtonClicked() -> Void {
        let newCategoryViewController = NewCategoryViewController()
        newCategoryViewController.delegate = self
        present(newCategoryViewController, animated: true)
    }
    
    private func switchToEditingVC() {
        let editingVC = EditCategoryViewController()
        present(editingVC, animated: true)
    }
}

// MARK: - Extensions

extension CategoriesViewController: NewCategoryViewControllerDelegate {
    func updateTableView() {
        categoryView.tableView.reloadData()
    }
    
    func setCategory(category: String?) {
        viewModel.setCategory(category: category)
    }
}

extension CategoriesViewController: CategoriesViewModelDelegate {
    func reloadDataCategories(_ array: [String]) {
        categoryView.categories = array
        categoryView.tableView.reloadData()
    }
}

extension CategoriesViewController: UICategoryListViewDelegate {
    
    func editCategory(at indexPath: IndexPath) {
        switchToEditingVC()
        viewModel.editCategory(at: indexPath)
    }
    
    
    func didDelete(at index: IndexPath) {
        let alert = UIAlertController(
            title: nil,
            message: "Эта категория точно не нужна?".localized(),
            preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(
            title: "Удалить".localized(),
            style: .destructive) { [weak self] _ in
                
                guard let self = self else { return }
                viewModel.deleteCategory(at: index)
            }
        
        let cancelAction = UIAlertAction(
            title: "Отменить",
            style: .cancel)
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true)
    }
    
    func didSelect(_ category: String) {
        delegate?.selectCategory(category)
        dismiss(animated: true) {}
    }
}
