//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Джами on 21.04.2023.
//

import UIKit

final class TrackersViewController: UIViewController, UICollectionViewDelegate {
    
    var categories = [TrackerCategory]()
    var completedTrackers = [TrackerRecord]()
    var visibleCategories = [TrackerCategory]()
    var dataManager = DataManager()
    //    {
    //        didSet {
    //            collectionView.reloadData()
    //        }
    //    }
    var currentDate: Date = .init()
    
   
    
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
        label.textColor = .custom.black
        label.font = UIFont.boldSystemFont(ofSize: 34)
        return label
    }()
    
    private lazy var searchField: UISearchTextField = {
        let searchField = UISearchTextField()
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.placeholder = "Поиск"
        searchField.font = UIFont.systemFont(ofSize: 17)
        searchField.delegate = self
        //searchField.addTarget(self, action: #selector(textFieldEdting(_:)), for: .editingChanged)
        
        return searchField
    }()
    
    //    private lazy var stubImage: UIImageView = {
    //        let image = UIImageView()
    //        image.translatesAutoresizingMaskIntoConstraints = false
    //        image.image = UIImage(named: "Star")
    //        return image
    //    }()
    //
    //    private lazy var stubLabel: UILabel = {
    //        let label = UILabel()
    //        label.translatesAutoresizingMaskIntoConstraints = false
    //        label.text = "Что будем отслеживать?"
    //        label.font = UIFont.systemFont(ofSize: 12)
    //        return label
    //    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        return datePicker
    }()
    
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 9
        layout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: "TrackerCell")
        collectionView.register(HeaderSectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderSectionView")
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Фильтры", for: .normal)
        button.backgroundColor = .custom.blue
        button.tintColor = .custom.white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.addTarget(self, action: #selector(addNewTracker), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .custom.white
        setUpConstraints()
        reloadData()
    }
    
    // MARK: - Helpers
    
    private func setUpConstraints() {  // stubImage, stubLabel,
        [addButton, header, datePicker, searchField, collectionView].forEach {view.addSubview($0)}
        
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
            
            //            stubImage.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 230),
            //            stubImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //
            //            stubLabel.topAnchor.constraint(equalTo: stubImage.bottomAnchor, constant: 8),
            //            stubLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            collectionView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func reloadData() {
        categories = dataManager.categories
        dateChanged()
    }
    
    
//        private func reloadVisibleCategories() {
//            let calendar = Calendar.current
//            let filterWeekDay = calendar.component(.weekday, from: datePicker.date)
//            let filterText = (searchField.text ?? "").lowercased()
//
//            visibleCategories = categories.compactMap { category in
//                let trackers = category.trackers.filter{ tracker in
//                    let textCondition = filterText.isEmpty ||
//                    tracker.name.lowercased().contains(filterText)
//                   let dateCondition = tracker.schedule.contains { weekDay in
//                        weekDay.value == filterWeekDay
//                    } == true
//
//
//                    return textCondition && dateCondition
//                }
//
//                if trackers.isEmpty {
//                    return nil
//                }
//
//               return TrackerCategory(title: category.title, trackers: trackers)
//            }
//            collectionView.reloadData()
//        }
    
    // MARK: - @objc
    
    @objc private func addNewTracker() {
        let trackerTypeViewController = TrackerTypeViewController()
        trackerTypeViewController.delegate = self
        present(trackerTypeViewController, animated: true)
    }
    
    
    @objc private func selectedFilter() {
        print("Tapped Filter")
    }
    
    @objc private func dateChanged() {
         // updateDataLabelTitle(with: datePicker.date)
       //   reloadVisibleCategories()
        
    }
}

// MARK: - UITextFieldDelegate

extension TrackersViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        // reloadVisibleCategories()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        print(#function, textField.text ?? "")
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension TrackersViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let tracker = visibleCategories[section].trackers
        return tracker.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrackerCell" , for: indexPath) as? TrackerCell else {return UICollectionViewCell()}
        
        let cellData = visibleCategories
        let tracker = cellData[indexPath.section].trackers[indexPath.row]
        
        cell.delegate = self
        
        let isCompletedToday = isTrackerCompletedToday(id: tracker.id)
        cell.configure(
            with: tracker,
            isCompletedToday: isCompletedToday,
            indexPath: indexPath)
        return cell
    }
    
    private func isTrackerCompletedToday(id: UUID) -> Bool {
        completedTrackers.contains { trackerRecord in
            let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
           return trackerRecord.id == id && isSameDay
        }
    }
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        print("numberOfSections - \(visibleCategories.count)")
        return visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderSectionView", for: indexPath) as? HeaderSectionView
        else {return UICollectionReusableView()}
        
        let titileCategory = categories[indexPath.section].title
        
        view.setTitle(text: titileCategory)
        
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       // let width = (collectionView.bounds.width - 41) / 2
        let width = (UIScreen.main.bounds.width - 41) / 2
        return CGSize(width: width, height: 148)
    }
}

// MARK: - TrackerCellDelegate

extension TrackersViewController: TrackerCellDelegate {
    func completeTracker(id: UUID, at indexPath: IndexPath) {
        let trackerRecord = TrackerRecord(id: id, date: datePicker.date)
        completedTrackers.append(trackerRecord)
        
        collectionView.reloadItems(at: [indexPath])
    }
    
    func uncompleteTracher(id: UUID, at indexPath: IndexPath) {
        completedTrackers.removeAll{trackerRecord in
            let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
            
            return trackerRecord.id == id && isSameDay
        }
        collectionView.reloadItems(at: [indexPath])
    }
}





extension TrackersViewController: TrackerStoreProtocol {
    func createTracker(_ tracker: Tracker, categoryName: String) {
        visibleCategories.append(.init(title: categoryName, trackers: [tracker]))
        print(tracker)
        print(categoryName)
        collectionView.reloadData()
    }
}
