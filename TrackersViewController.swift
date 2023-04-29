//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Джами on 21.04.2023.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    //    var categories = [TrackerCategory]()
    //    var completedTrackers = [TrackerRecord]()
    lazy var trackerTypeViewController = TrackerTypeViewController()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let buttonImage = UIImage(named: "AddButton")
        button.setImage(buttonImage, for: .normal)
        button.addTarget(self, action: #selector(addNewTracker), for: .touchUpInside)
        return button
    }()
    
    private lazy var header: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Трекеры"
        label.font = UIFont.boldSystemFont(ofSize: 34)
        return label
    }()
    
    private lazy var searchField: UISearchTextField = {
        let searchField = UISearchTextField()
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.placeholder = "Поиск"
        searchField.font = UIFont.systemFont(ofSize: 17)
        return searchField
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
        label.text = "Что будем отслеживать?"
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru_RU")
//        datePicker.calendar = Calendar(identifier: .iso8601)
        return datePicker
    }()
    
 
    //        private lazy var collectionView: UICollectionView {
    //            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    //            collectionView.translatesAutoresizingMaskIntoConstraints = false
    //            collectionView.delegate = self
    //            collectionView.dataSource = self
    //
    //        }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteDay
        setUpConstraints()
    }
    
    
    private func setUpConstraints() {
        [addButton, header, datePicker, searchField, stubImage, stubLabel].forEach {view.addSubview($0)}
        
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            header.leadingAnchor.constraint(equalTo: addButton.leadingAnchor),
            header.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 13),
            
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            //располагается по центру элемента header по вертикали
            datePicker.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            datePicker.widthAnchor.constraint(equalToConstant: 100),
            
            searchField.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 7),
            searchField.heightAnchor.constraint(equalToConstant: 36),
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            stubImage.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 230),
            stubImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stubLabel.topAnchor.constraint(equalTo: stubImage.bottomAnchor, constant: 8),
            stubLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    
    @objc
    func addNewTracker() {
        present(trackerTypeViewController, animated: true)
    }
}

// MARK: - Extensions

//extension TrackersViewController: UITextFieldDelegate {
//
//}
//
//extension TrackersViewController: UICollectionViewDelegateFlowLayout {
//
//}
//
//extension TrackersViewController: UICollectionViewDataSource {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//    }
//}


