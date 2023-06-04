//
//  TrackerTypeViewController.swift
//  Tracker
//
//  Created by Джами on 28.04.2023.
//

import UIKit

final class TrackerTypeViewController: UIViewController {
    
    weak var delegate: TrackerTypeProtocol?
    var trackerStore: TrackerStoreProtocol?
    
    private lazy var titileLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Создание трекера"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var regularButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.setTitle("Привычка", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(regularButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var irregularButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.setTitle("Нерегулярные событие", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
       // button.addTarget(self, action: #selector(addNewTracker), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 16
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = UIStackView.Distribution.fillEqually
        stackView.addArrangedSubview(regularButton)
        stackView.addArrangedSubview(irregularButton)
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .custom.white
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        [titileLabel ,stackView].forEach {view.addSubview($0)}
        
        NSLayoutConstraint.activate([
            titileLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            titileLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 135)
        ])
    }
    
    @objc
    func regularButtonClicked() {
        let vc = TrackerCreationViewController()
        vc.trackerType = self
        present(vc, animated: true)
    }
}

// MARK: - Extensions

extension TrackerTypeViewController: TrackerTypeProtocol {
    func createTracker(_ tracker: Tracker, categoryName: String) {
        dismiss(animated: true) {
            self.delegate?.createTracker(tracker, categoryName: categoryName)
        }
    }
}
