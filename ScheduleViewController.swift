
import UIKit

// MARK: - protocol ScheduleViewControllerDelegate

protocol ScheduleViewControllerDelegate: AnyObject {
    func createSchedule (schedule: [WeekDay])
}

// MARK: - final class ScheduleViewController

final class ScheduleViewController: UIViewController {
    
    weak var delegate: ScheduleViewControllerDelegate?
    var selectedSchedule: [Int] = []
    private var arrayDays = WeekDay.allCases
    private var selectIndex = [Int]()
    
    private lazy var headerTitile: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Расписание"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(doneButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var scheduleTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.register(ButtonCell.self, forCellReuseIdentifier: "ButtonCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .custom.white
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        [headerTitile, doneButton, scheduleTableView].forEach {view.addSubview($0)}
        
        NSLayoutConstraint.activate([
            headerTitile.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            headerTitile.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            scheduleTableView.topAnchor.constraint(equalTo: headerTitile.bottomAnchor, constant: 30),
            scheduleTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scheduleTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scheduleTableView.heightAnchor.constraint(equalToConstant: 7 * 75),
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // MARK: - @objc func
    
    @objc func doneButtonClicked() {
        doneButton.isEnabled = false
        
        //1
        var selectDay = [WeekDay]()
        for row in selectIndex {
            let day = arrayDays[row]
            selectDay.append(day)
        }
        delegate?.createSchedule(schedule: selectDay)
        //  print("Дни недели со ScheduleVC -\(selectDay.compactMap({$0.shortDay}))")
        dismiss(animated: true)
    }
    
    @objc private func selectSwitch(_ sender: UISwitch) {
        let row = sender.tag
        if let index = selectIndex.firstIndex(of: row) {
            selectIndex.remove(at: index)
        } else {
            selectIndex.append(row)
        }
        scheduleTableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
    }
}

// MARK: - ScheduleViewController extension

extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayDays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as? ButtonCell else {return UITableViewCell()}
        cell.textLabel?.text = arrayDays[indexPath.row].value
        
        let switchView = UISwitch(frame: .zero)
        switchView.isOn = selectIndex.contains(indexPath.row)
        switchView.onTintColor = .custom.blue
        switchView.tag = indexPath.row
        switchView.addTarget(self, action: #selector(selectSwitch(_:)), for: .valueChanged)
        cell.accessoryView = switchView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
