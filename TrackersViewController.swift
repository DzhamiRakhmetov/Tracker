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
    private let dataManager = DataManager.shared
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
        searchField.addTarget(self, action: #selector(searchChanged(_:)), for: .editingChanged)
        
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
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
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
    
    
    var isHiddenPlacholder: Bool = false {
        willSet {
            stubImage.isHidden = newValue
            stubLabel.isHidden = newValue
        }
    }
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .custom.white
        setUpConstraints()
        reloadData()
    }
    
    // MARK: - Helpers
    
    private func setUpConstraints() {  //
        [addButton, header, datePicker, searchField, stubImage, stubLabel, collectionView].forEach {view.addSubview($0)}
        
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
            stubLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            collectionView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func reloadData() {
        categories = dataManager.categories
        dateChanged(datePicker)
    }
  
    
    private func reloadVisibleCategories(text: String?, date: Date) {
        let calendar = Calendar.current
        let filterWeekDay = calendar.component(.weekday, from: date)
        
        let selectWeekday = WeekDay(rawValue: filterWeekDay)
        let filterText = (text ?? "").lowercased()
        
        visibleCategories = categories.compactMap { category in
            
            let trackers = category.trackers.filter { tracker in
                //1
                let textCondition = filterText.isEmpty ||
                tracker.name.lowercased().contains(filterText)
                
                //2
                guard let selectWeekday = selectWeekday  else {return textCondition }
                
                //3
                let schedule = tracker.schedule.contains { value in
                    value == selectWeekday
                }
                
                return textCondition && schedule
            }
            
            if trackers.isEmpty {
                return nil
            }
            
            return TrackerCategory(title: category.title, trackers: trackers)
        }
        
        collectionView.reloadData()
    }
    
    // MARK: - @objc
    
    @objc private func addNewTracker() {
        let trackerTypeViewController = TrackerTypeViewController()
        trackerTypeViewController.delegate = self
        present(trackerTypeViewController, animated: true)
    }
    
    
    @objc private func selectedFilter() {
        print("Tapped Filter")
    }
    
    @objc private func dateChanged(_ picker: UIDatePicker) {
        currentDate = datePicker.date.startOfDay
        reloadVisibleCategories(text: searchField.text, date: picker.date)
    }
    
    @objc private func searchChanged(_ search: UISearchTextField) {
        reloadVisibleCategories(text: search.text, date: datePicker.date)
    }
}

// MARK: - UITextFieldDelegate

extension TrackersViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        reloadVisibleCategories(text: searchField.text, date: datePicker.date)
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        print("numberOfSections - \(visibleCategories.count)")
        let count = visibleCategories.count
        isHiddenPlacholder = count > 0
        return count
    }
    
    
    fileprivate func setupCell(_ indexPath: IndexPath, _ cell: TrackerCell) {
        
        let cellData = visibleCategories
        let tracker = cellData[indexPath.section].trackers[indexPath.row]
        cell.delegate = self
        
        let isCompletedToday = isTrackerCompletedToday(id: tracker.id)
        let completedDays = completedTrackers.filter { $0.id == tracker.id}.count
        cell.configure(
            with: tracker,
            isCompletedToday: isCompletedToday,
            completedDays: completedDays,
            selectedDate: datePicker.date,
            indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrackerCell" , for: indexPath) as? TrackerCell else {return UICollectionViewCell()}
        
        setupCell(indexPath, cell)
        return cell
    }
    
    private func isTrackerCompletedToday(id: UUID) -> Bool {
        completedTrackers.contains { trackerRecord in
            let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
           return trackerRecord.id == id && isSameDay
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderSectionView", for: indexPath) as? HeaderSectionView
        else {return UICollectionReusableView()}
        
        let titileCategory = visibleCategories[indexPath.section].title
        view.setTitle(text: titileCategory)
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 41) / 2
        return CGSize(width: width, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: 30), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
}

// MARK: - TrackerCellDelegate

extension TrackersViewController: TrackerCellDelegate {
    func completeTracker(_ trackerCell: TrackerCell, id: UUID, at indexPath: IndexPath, isOn: Bool) {
        
        isOn ? uncompleteTracher(id, indexPath) : completeTracker(id, indexPath)
        print("*****")
        completedTrackers.forEach({print($0.id)})
        print("*****")
        
        collectionView.performBatchUpdates {
            setupCell(indexPath, trackerCell)
        }
    }
    
    private func completeTracker(_ id: UUID, _ indexPath: IndexPath) {
        let trackerRecord = TrackerRecord(id: id, date: datePicker.date)
        completedTrackers.append(trackerRecord)
    }
    
    private func uncompleteTracher(_ id: UUID, _ indexPath: IndexPath) {
        completedTrackers.removeAll{ trackerRecord in
            let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
            
            return trackerRecord.id == id && isSameDay
        }
    }
}



extension TrackersViewController: TrackerStoreProtocol {
    func createTracker(_ tracker: Tracker, categoryName: String) {
//        categories.append(.init(title: categoryName, trackers: [tracker]))
//        collectionView.reloadData()
        dataManager.categories.append(.init(title: categoryName, trackers: [tracker]))
        reloadData()
        collectionView.reloadData()
        print(tracker)
        print(categoryName)
    }
}
