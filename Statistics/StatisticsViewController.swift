import UIKit

final class StatisticsViewController: UIViewController {
    
    private let trackerRecordStore = TrackerRecordStore()
    private var completedTrackers: Int = 0
    
    private lazy var header: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Статистика".localized()
        label.font = UIFont.boldSystemFont(ofSize: 34)
        return label
    }()
    
    private lazy var stubImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "statistics")
        return imageView
    }()
    
    private lazy var stubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Анализировать пока нечего".localized()
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = false
        tableView.register(StatisticsTableCell.self, forCellReuseIdentifier: "StatisticsTableCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .custom.white
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .custom.white
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()     
    }
    
    private func setupConstraints() {

        [header, stubImageView, stubLabel, tableView].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            stubImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 20),
            
            stubLabel.topAnchor.constraint(equalTo: stubImageView.bottomAnchor, constant: 8),
            stubLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 65),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func checkForStub() {
        completedTrackers = trackerRecordStore.fetchTrackerRecords().count
        stubLabel.isHidden = completedTrackers > 0
        stubImageView.isHidden = completedTrackers > 0
        tableView.isHidden = completedTrackers == 0
    }
}

// MARK: - extension

extension StatisticsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StatisticsTableCell")
                as? StatisticsTableCell else { return UITableViewCell() }
        
        checkForStub()
        
        cell.set(title: "Трекеров завершено".localized())
        cell.set(value: completedTrackers)
        return cell 
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        102
    }
}

