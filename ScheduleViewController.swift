//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Джами on 03.05.2023.
//

import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func createSchedule (schedule: [WeekDay])
}

final class ScheduleViewController: UIViewController {
    
    weak var delegate: ScheduleViewControllerDelegate?
    var selectedSchedule: [WeekDay] = []
    
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
    
//    private func setDoneButton(){
//        if selectedSchedule.isEmpty {
//            doneButton.backgroundColor = .custom.gray
//            doneButton.isEnabled = true
//        } else {
//            doneButton.backgroundColor = .custom.black
//            doneButton.isEnabled = false
//        }
//    }
    
    private func switchStatus() {
        for (index, weekDay) in WeekDay.allCases.enumerated() {
            let indexPath = IndexPath(row: index, section: 0)
            let cell = scheduleTableView.cellForRow(at: indexPath)
            guard let switchView = cell?.accessoryView as? UISwitch else {return}
            
            if switchView.isOn {
                selectedSchedule.append(weekDay)
            } else {
                selectedSchedule.removeAll { $0 == weekDay }
            }
            //setDoneButton()
        }
    }
    
    @objc func doneButtonClicked() {
        switchStatus()
        delegate?.createSchedule(schedule: selectedSchedule)
        print("Дни недели со ScheduleVC -\(selectedSchedule)")
        scheduleTableView.reloadData()
        dismiss(animated: true)
    }
}

extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WeekDay.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as? ButtonCell else {return UITableViewCell()}
        cell.textLabel?.text = WeekDay.allCases[indexPath.row].value
        cell.backgroundColor = .custom.backgroundDay
        
        let switchView = UISwitch(frame: .zero)
        switchView.setOn(false, animated: true)
        switchView.onTintColor = .custom.blue
        switchView.tag = indexPath.row
        cell.accessoryView = switchView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
