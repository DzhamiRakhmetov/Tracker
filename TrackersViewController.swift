
import UIKit

final class TrackersViewController: UIViewController, UICollectionViewDelegate {
    
    var categoryStore: TrackerCategoryStore
    var completedTrackers: [TrackerRecord]
    var visibleCategories: [TrackerCategory]
    var trackerStore: TrackerStore
    var trackerRecordStore: TrackerRecordStore
    var currentDate: Date = .init()
    var pinnedTrackers : [Tracker] = []

    
    private let analyticsService = AnalyticsService()
    private var selectedFilter: Filter?
    private let databaseManager = DatabaseManager.shared
    private var categories: [TrackerCategory] = []
    
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let buttonImage = UIImage(named: "AddButton")?.withTintColor(.label)
        button.setImage(buttonImage, for: .normal)
        button.addTarget(self, action: #selector(addNewTracker), for: .touchUpInside)
        return button
    }()
    
    private lazy var header: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Трекеры".localized()
        label.font = UIFont.boldSystemFont(ofSize: 34)
        return label
    }()
    
    private lazy var searchField: UISearchTextField = {
        let searchField = UISearchTextField()
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.placeholder = "Поиск".localized()
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
        label.text = "Что будем отслеживать?".localized()
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        //        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.locale = .current
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
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Фильтры".localized(), for: .normal)
        button.backgroundColor = .custom.blue
        button.tintColor = .custom.white
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.addTarget(self, action: #selector(showFilters), for: .touchUpInside)
        return button
    }()
    
    var isHiddenPlacholder: Bool = false {
        willSet {
            stubImage.isHidden = newValue
            stubLabel.isHidden = newValue
        }
    }
    // MARK: - Lifecycle
    
    init(
        categories: TrackerCategoryStore = TrackerCategoryStore(), // viewModel
        completedTrackers: [TrackerRecord] = [], // viewModel
        visibleCategories: [TrackerCategory] = [], // viewModel
        trackerStore: TrackerStore = TrackerStore(), // viewModel
        trackerRecordStore: TrackerRecordStore = TrackerRecordStore()
    ) {
        self.categoryStore = categories
        self.completedTrackers = completedTrackers
        self.visibleCategories = visibleCategories
        self.trackerStore = trackerStore
        self.trackerRecordStore = trackerRecordStore
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .custom.viewBackgroundColor
        setUpConstraints()
        reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyticsService.report(event: "open", params: ["main_screen": "viewDidAppear"])
        print("Event: open")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        analyticsService.report(event: "close", params: ["main_screen": "viewDidDisappear"])
        print("Event: close")
    }
    
    // MARK: - Helpers
    
    private func setUpConstraints() {  //
        [addButton, header, datePicker, searchField, stubImage, stubLabel, collectionView, filterButton].forEach {view.addSubview($0)}
        
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
            
            stubImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 51),
            
            stubLabel.topAnchor.constraint(equalTo: stubImage.bottomAnchor, constant: 8),
            stubLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            collectionView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: -16),
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            filterButton.widthAnchor.constraint(equalToConstant: 114)
        ])
    }
    
    private func reloadData() {
        categoryStore = TrackerCategoryStore()
        dateChanged(datePicker)
    }
    
    
    private func reloadVisibleCategories(text: String?, date: Date) {
        let calendar = Calendar.current
        let filterWeekDay = calendar.component(.weekday, from: date)
        let filterText = (text ?? "").lowercased()
        let selectWeekday = WeekDay.fromInt(filterWeekDay)
        
        visibleCategories = trackerStore.fetchTrackers().compactMap { category in
            
            let trackers = category.trackers.filter { tracker in
                let textCondition = filterText.isEmpty || tracker.name.lowercased().hasPrefix(filterText)
                
                guard let schedule = tracker.schedule  else { return textCondition }
                
                let isScheduleCorrect = schedule.contains { value in
                    value == WeekDay.fromWeekDay(selectWeekday)
                }
                return textCondition && isScheduleCorrect
            }
            if trackers.isEmpty {
                return nil
            }
            pinnedTrackers = trackers.filter{ $0.isPinned }
            
            return TrackerCategory(title: category.title, trackers: trackers)
        }
        collectionView.reloadData()
    }
    
    // MARK: - @objc
    
    @objc private func addNewTracker() {
        let trackerTypeViewController = TrackerTypeViewController()
        trackerTypeViewController.delegate = self
        present(trackerTypeViewController, animated: true)
        analyticsService.report(event: "click", params: ["main_screen": "add_track"])
        print("Event : click addNewTracker")
    }
    
    @objc private func showFilters() {
        let filterVC = FiltersViewController()
        filterVC.delegate = self
        filterVC.selectedFilter = selectedFilter
        present(filterVC, animated: true)
        analyticsService.report(event: "click", params: ["main_screen": "filter"])
        print("Event : click showFilters")
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
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension TrackersViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 && !pinnedTrackers.isEmpty {
            return pinnedTrackers.count
        }
        
        let index = !pinnedTrackers.isEmpty ? section - 1 : section
        let count = visibleCategories[index].trackers.count
        return count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
    
        var count = visibleCategories.count
        isHiddenPlacholder = count > 0
        filterButton.isHidden = count == 0
        
        if !pinnedTrackers.isEmpty {
         count += 1
        }
        return count
    }
    
    
    fileprivate func setupCell(_ indexPath: IndexPath, _ cell: TrackerCell) {
        
        // guard let tracker = trackerStore.fetchResultController.fetchedObjects?[indexPath.section] else {return}
        let tracker : Tracker
        
        if indexPath.section == 0 && !pinnedTrackers.isEmpty {
            tracker = pinnedTrackers[indexPath.row]
        } else {
            let index = !pinnedTrackers.isEmpty ? indexPath.section - 1 : indexPath.section
           tracker = visibleCategories[index].trackers[indexPath.row]
        }
        
        cell.delegate = self
        let id = tracker.id
        let isCompletedToday = isTrackerCompletedToday(id: id)
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
        completedTrackers = trackerRecordStore.fetchTrackerRecords()
        
        return completedTrackers.contains { trackerRecord in
            let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
            return trackerRecord.id == id && isSameDay
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderSectionView", for: indexPath) as? HeaderSectionView
        else {return UICollectionReusableView()}
        
        let titileCategory: String
        
        if indexPath.section == 0 && !pinnedTrackers.isEmpty {
            titileCategory = "Закрепленные"
        } else {
            let index = !pinnedTrackers.isEmpty ? indexPath.section - 1 : indexPath.section
            
            titileCategory = categoryStore.fetchCategoryName(index: index) ?? "---"
        }
        
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
    
    func pinTrackerTapped(at indexPath: IndexPath) {
        
        let tracker : Tracker
        if indexPath.section == 0 && !pinnedTrackers.isEmpty {
            tracker = pinnedTrackers[indexPath.row]
        } else {
            tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        }
        
        if tracker.isPinned {
            // сохранить с новым свойством в хранилище
            pinnedTrackers.removeAll{ $0.id == tracker.id }
        } else {
            pinnedTrackers.append(tracker)
        }
        trackerStore.pinTracker(at: indexPath, isPinned: !tracker.isPinned)
        reloadVisibleCategories(text: searchField.text, date: datePicker.date)
    }
    
    func editTracker(at indexPath: IndexPath) {
        
//        guard let tracker = trackerStore.getTrackerAt(indexPath: indexPath) else { return }
//              let category = trackerStore.
//        let dayCounter =
//
        let editVC = TrackerCreationViewController(trackerType: .existing)
//        editVC.edit(existing: tracker, in: category, with: dayCounter, isPinned: tracker.isPinned)
   
        present(editVC, animated: true)
    }
    
    func deleteTracker(at indexPath: IndexPath) {
        let alert = UIAlertController(
            title: nil,
            message: NSLocalizedString("Уверены что хотите удалить трекер?", comment: ""),
            preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(
            title: NSLocalizedString("Удалить", comment: ""),
            style: .destructive) { [weak self] _ in
                
                guard let self = self else { return }
                do {
                    try self.trackerStore.deleteTracker(at: indexPath)
                    reloadData()
                    collectionView.reloadData()
                } catch { }
            }
        
        let cancelAction = UIAlertAction(
            title: NSLocalizedString("Отменить", comment: ""),
            style: .cancel)
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true)
    }
    
    func completeTracker(_ trackerCell: TrackerCell, id: UUID, at indexPath: IndexPath, isOn: Bool) {
        isOn ? uncompleteTracker(id, indexPath) : completeTracker(id, indexPath)
        completedTrackers.forEach({print($0.id)})
        collectionView.performBatchUpdates {
            setupCell(indexPath, trackerCell)
        }
    }
    
    private func completeTracker(_ id: UUID, _ indexPath: IndexPath) {
        let trackerRecord = TrackerRecord(id: id, date: datePicker.date)
        completedTrackers.append(trackerRecord)
        trackerRecordStore.addTrackerRecord(tracker: trackerRecord)
        print("completedTrackers - \(completedTrackers.count)")
    }
    
    private func uncompleteTracker(_ id: UUID, _ indexPath: IndexPath) {
        let trackerRecord = TrackerRecord(id: id, date: datePicker.date)
        trackerRecordStore.deleteTrackerRecord(tracker: trackerRecord)
        print("Deleted Trackers - \(trackerRecord)")
        
        completedTrackers.removeAll{ trackerRecord in
            let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
            
            return trackerRecord.id == id && isSameDay
        }
    }
}

// MARK: - extension TrackerStoreProtocol

extension TrackersViewController: TrackerStoreProtocol {
    
    func createTracker(_ tracker: Tracker, categoryName: String) {
        let trackerStore = TrackerStore()
        do {
            try trackerStore.addTracker(tracker: tracker, in: categoryName)
        } catch let error {
            print(error.localizedDescription)
        }
        reloadData()
        collectionView.reloadData()
        print(tracker)
        print(categoryName)
    }
}

// MARK: - Extension

extension TrackersViewController: FiltersViewControllerDelegate {
    
    func filterSelected(filter: Filter) {
        //        selectedFilter = filter
        //
        //        switch filter {
        //        case .all:
        //
        //        case.completed:
        //
        //        case .today:
        //
        //        case .uncompleted:
        //
        //        }
    }
}




