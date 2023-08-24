import UIKit

protocol FiltersViewControllerDelegate: AnyObject {
    func filterSelected(filter: Filter)
}

final class FiltersViewController: UIViewController {
    
    weak var delegate: FiltersViewControllerDelegate?
    
    private let filters: [Filter] = Filter.allCases
    var selectedFilter: Filter?
    
    private lazy var screenTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Фильтры"
        label.font =  UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .custom.ypBlack
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.separatorColor = .custom.gray
        tableView.register(ButtonCell.self, forCellReuseIdentifier: "ButtonCell")
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        view.backgroundColor = .custom.white
    }
    
    private func setupConstraints() {
        [screenTitleLabel, tableView].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            screenTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            screenTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: screenTitleLabel.bottomAnchor, constant: 38),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
}

// MARK: - UITableViewDelegate

extension FiltersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedFilter = Filter(rawValue: indexPath.row) else { return }
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
       
        // TODO: - применение выбранного фильтра
        delegate?.filterSelected(filter: selectedFilter)
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource

extension FiltersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell") as? ButtonCell else {
            return UITableViewCell()
        }
        let filter = filters[indexPath.row].string
        cell.textLabel?.text = filter
        cell.accessoryType = selectedFilter == Filter(rawValue: indexPath.row) ? .checkmark : .none

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

