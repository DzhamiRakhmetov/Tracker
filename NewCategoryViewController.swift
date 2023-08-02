
import UIKit

// MARK: - protocol NewCategoryViewControllerDelegate

protocol NewCategoryViewControllerDelegate: AnyObject {
    func setCategory(category: String?)
}

// MARK: - final class NewCategoryViewController

final class NewCategoryViewController: UIViewController {
    
    weak var delegate: NewCategoryViewControllerDelegate?
    private var newCategoryName: String?
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Категория"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var categoryNameTextFiled: UITextField = {
        let textFiled = UITextField()
        textFiled.translatesAutoresizingMaskIntoConstraints = false
        textFiled.delegate = self
        textFiled.layer.cornerRadius = 16
        textFiled.layer.masksToBounds = true
        textFiled.backgroundColor = .custom.backgroundDay
        textFiled.clearButtonMode = .whileEditing
        textFiled.returnKeyType = .done                      // клавиша "Готово"
        textFiled.enablesReturnKeyAutomatically = true      // "Готово" недоступно пока пользователь не ввел текст
        textFiled.smartInsertDeleteType = .no              // запрет вставки
        textFiled.indent(size: 16)
        textFiled.placeholder = "Введите название категории"
        textFiled.font = UIFont.systemFont(ofSize: 17)
        
        return textFiled
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .custom.gray
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(doneButtonClicked), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpConstraints()
        view.backgroundColor = .custom.white
    }
    
    private func setUpConstraints() {
        [categoryLabel, categoryNameTextFiled, doneButton].forEach {view.addSubview($0)}
        
        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            categoryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            categoryNameTextFiled.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 38),
            categoryNameTextFiled.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryNameTextFiled.heightAnchor.constraint(equalToConstant: 75),
            categoryNameTextFiled.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func enableDoneButton(){
        doneButton.backgroundColor = .custom.black
        doneButton.isUserInteractionEnabled = true
    }
    
    func disableDoneButton() {
        doneButton.backgroundColor = .custom.gray
        doneButton.isUserInteractionEnabled = false
    }
    
    @objc
    func doneButtonClicked() {
        let text = categoryNameTextFiled.text
        dismiss(animated: true) {
            print("New Category - \(String(describing: self.newCategoryName))")
            self.delegate?.setCategory(category: text)
            self.disableDoneButton()
            self.newCategoryName = nil
            self.categoryNameTextFiled.text = nil
        }
    }
}

// MARK: - Extensions

extension NewCategoryViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            disableDoneButton()
        } else {
            enableDoneButton()
            newCategoryName = textField.text
        }
    }
}
