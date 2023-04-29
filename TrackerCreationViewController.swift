//
//  TrackerCreationViewController.swift
//  Tracker
//
//  Created by Джами on 28.04.2023.
//

import UIKit

final class TrackerCreationViewController: UIViewController {
    
    private lazy var titileLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Новая привычка"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var trackerTextFiled: UITextField = {
        let textFiled = UITextField()
        textFiled.delegate = self
        textFiled.translatesAutoresizingMaskIntoConstraints = false
        textFiled.layer.cornerRadius = 16
        textFiled.layer.masksToBounds = true
        textFiled.placeholder = "Введите название трекера"
        textFiled.backgroundColor = .backgroundDay
        textFiled.clearButtonMode = .whileEditing
        textFiled.returnKeyType = .done                      // клавиша "Готово"
        textFiled.enablesReturnKeyAutomatically = true      // "Готово" недоступно пока пользователь не ввел текст
        textFiled.smartInsertDeleteType = .no              // запрет вставки
        textFiled.indent(size: 16)                        // отступ в textField
        textFiled.font = UIFont.systemFont(ofSize: 17)
        return textFiled
    }()
    
    private lazy var buttonsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
       // tableView.register(ButtonCell.self, forCellReuseIdentifier: ButtonCell.identifier)
       // tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    //    private lazy var emojiLabel: UILabel = {
    //        let label = UILabel()
    //        label.translatesAutoresizingMaskIntoConstraints = false
    //        label.text = "Emoji"
    //        label.font = UIFont.boldSystemFont(ofSize: 10)
    //        return label
    //    }()
    //
    //    private lazy var colorLabel: UILabel = {
    //        let label = UILabel()
    //        label.translatesAutoresizingMaskIntoConstraints = false
    //        label.text = "Цвет"
    //        label.font = UIFont.boldSystemFont(ofSize: 10)
    //        return label
    //    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteDay
        setUpConstraints()
    }
    
    
    private func setUpConstraints() {
        [titileLabel ,trackerTextFiled, buttonsTableView].forEach {view.addSubview($0)}
        
        NSLayoutConstraint.activate([
            titileLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            titileLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            trackerTextFiled.topAnchor.constraint(equalTo: titileLabel.bottomAnchor, constant: 38),
            trackerTextFiled.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackerTextFiled.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            trackerTextFiled.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
}

// MARK: - Extensions

extension TrackerCreationViewController: UITextFieldDelegate {
    
}


//extension TrackerCreationViewController: UITableViewDelegate {
//
//}

extension TrackerCreationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
