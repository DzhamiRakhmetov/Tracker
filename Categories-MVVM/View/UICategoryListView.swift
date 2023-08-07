import UIKit

// MARK: - Protocol
protocol UICategoryListViewDelegate: AnyObject {
    func didSelect(_ category: String)
}

// MARK: - UICategoryListView Class

final class UICategoryListView: UIView {
    weak var delegate: UICategoryListViewDelegate?
    var didSelectCategory: (() -> ())?
    var categories: [String] = [] {
        didSet {
            tableView.refreshControl?.endRefreshing()
            tableView.reloadData()
        }
    }
    
    private lazy var header: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Категория"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var stubImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "Star")
        return image
    }()
    
    private lazy var stubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Привычки и события можно \n объединить по смыслу"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var addCategoryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.setTitle("Добавить категорию", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(doneButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.register(ButtonCell.self, forCellReuseIdentifier: "ButtonCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        [header, stubImage, stubLabel, addCategoryButton, tableView].forEach {self.addSubview($0)}
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            header.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 38),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            
            stubImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stubImage.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor, constant: -30),
            
            stubLabel.topAnchor.constraint(equalTo: stubImage.bottomAnchor, constant: 8),
            stubLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            addCategoryButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // MARK: - @objc func
    
    @objc func doneButtonClicked() {
        didSelectCategory?()
    }
}

// MARK: - Extension

extension UICategoryListView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as? ButtonCell else {return UITableViewCell()}
        let value = categories[indexPath.row]
        
        cell.contentView.backgroundColor = .custom.backgroundDay
        cell.label.text = value
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        let value = categories[indexPath.row]
        delegate?.didSelect(value)
    }
}
