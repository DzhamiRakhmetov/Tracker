//
//  TrackerCreationViewController.swift
//  Tracker
//
//  Created by Джами on 28.04.2023.
//

import UIKit

protocol TrackerStoreProtocol: AnyObject {
    func createTracker(_ tracker: Tracker, categoryName: String)
   
}

final class TrackerCreationViewController: UIViewController {
    
    var dataForTableView = ["Категория", "Расписание"]
    var trackerStore: TrackerStoreProtocol?
    var trackerType: TrackerType?
    
    private var selectedTrackerName: String?
    private var selectedCategory: String?
    private var selectedSchedule: [WeekDay] = []
    private var selectedColor: UIColor?
    private var selectedEmoji: String?
    private var scheduleSubTitle: String = ""
    
    private let emojies: [String] = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
    private lazy var buttonsTableViewHeight: CGFloat = 150
    
    private let colors: [UIColor] = SelectionColor.allCases.compactMap({UIColor(named: $0.rawValue)})
    
    private var contentSize : CGSize  {
        CGSize(width: view.frame.width, height: view.frame.height + 105)
    }
    
    lazy var trackersViewController = TrackersViewController()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.frame.size = contentSize
        return contentView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentSize = contentSize
        scrollView.frame = view.bounds
        return scrollView
    }()
    
    private lazy var titileLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        if trackerType == .regular {
            label.text = "Новая привычка"
        } else {
            label.text = "Новое нерегулярное действие"
        }
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
        textFiled.backgroundColor = .custom.backgroundDay
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
        tableView.register(ButtonCell.self, forCellReuseIdentifier: "ButtonCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    private lazy var scheduleButtonTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
//    private lazy var scheduleButtonSubTitle: UILabel = {
//         let label = UILabel()
//         label.text = scheduleSubTitle
//         label.font = .systemFont(ofSize: 16)
//         label.translatesAutoresizingMaskIntoConstraints = false
//         return label
//     }()
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Emoji"
        label.font = UIFont.boldSystemFont(ofSize: 19)
        return label
    }()
    
    private lazy var colorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Цвет"
        label.font = UIFont.boldSystemFont(ofSize: 19)
        return label
    }()
    
    private lazy var emojisCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(EmojiAndColorCell.self, forCellWithReuseIdentifier: "EmojiAndColorCell")
        return collectionView
    }()
    
    private lazy var colorsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(EmojiAndColorCell.self, forCellWithReuseIdentifier: "EmojiAndColorCell")
        return collectionView
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.custom.red, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = .custom.white
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.custom.red.cgColor
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(.custom.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = .custom.gray
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(createAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var charactersLimitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ограничение 38 символов"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .custom.red
        label.alpha = 0.0 // непрозрачныйу
        return label
    }()
    
    private lazy var selectedBackgroundForEmoji: UIView = {
       let view = UIView()
        view.backgroundColor = .custom.gray
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var selectedBackgroundForColor: UIView = {
       let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 3
        view.layer.masksToBounds = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .custom.white
        setUpViewController()
        setUpConstraints()
    }
    
    
    private func setUpConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [ titileLabel ,trackerTextFiled, emojiLabel, colorLabel, buttonsTableView, emojisCollectionView, colorsCollectionView, cancelButton, createButton].forEach {contentView.addSubview($0)}
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titileLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titileLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            trackerTextFiled.topAnchor.constraint(equalTo: titileLabel.bottomAnchor, constant: 38),
            trackerTextFiled.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            trackerTextFiled.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            trackerTextFiled.heightAnchor.constraint(equalToConstant: 75),
            
            buttonsTableView.topAnchor.constraint(equalTo: trackerTextFiled.bottomAnchor, constant: 24),
            buttonsTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            buttonsTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            buttonsTableView.heightAnchor.constraint(equalToConstant: buttonsTableViewHeight),
            
            emojiLabel.topAnchor.constraint(equalTo: buttonsTableView.bottomAnchor, constant: 32),
            emojiLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            
            emojisCollectionView.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 30),
            emojisCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            emojisCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            emojisCollectionView.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 57) / 2),
            
            colorLabel.topAnchor.constraint(equalTo: emojisCollectionView.bottomAnchor, constant: 45),
            colorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            
            colorsCollectionView.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 30),
            colorsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            colorsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            colorsCollectionView.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 57) / 2),
            
            cancelButton.topAnchor.constraint(equalTo: colorsCollectionView.bottomAnchor, constant: 45),
            cancelButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            //cancelButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            
            createButton.topAnchor.constraint(equalTo: colorsCollectionView.bottomAnchor, constant: 45),
            createButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 8),
            createButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor)
        ])
    }
    
    private func setUpViewController() {
        if trackerType == .irregular {
            selectedSchedule = []
            buttonsTableViewHeight = 75
            buttonsTableView.separatorStyle = .none
        }
    }
    
    private func tapScheduleCell(){
        let scheduleViewController = ScheduleViewController()
        scheduleViewController.delegate = self
        present(scheduleViewController, animated: true)
    }
    
    private func tapCategoriesCell(){
        let vc = CategoriesViewController()
        vc.delegate = self
        present(vc, animated: true)
    }
    
    
    private func setScheduleButtonSubTitle(with additionalText: String?) {
        let scheduleButtonSubTitile = buttonsTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? ButtonCell
        scheduleButtonSubTitile?.setup(selectedCategory)
    }
    
//    private func showCharactersLimitLabel(){
//        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: scrollView.contentSize.height + 35)
//
//    }
        @objc func createAction() {
        guard let selectedCategory = selectedCategory else {
            //TODO: alert
            return
        }
            
        let newTracker = Tracker(
            id: UUID(), //!!!!!
            name: trackerTextFiled.text ?? "",
            color: selectedColor ?? .custom.black,
            emoji: selectedEmoji ?? "",
            schedule: [1]) // !!!!! selectedSchedule)
        
        print("\(newTracker)")
        print("selected schedule - \(selectedSchedule)")
        dismiss(animated: true) {
            self.trackerStore?.createTracker(newTracker, categoryName: selectedCategory)
        }
    }
    
    @objc func cancelAction() {
        dismiss(animated: true)
    }
}

// MARK: - Textfiled Extensions

extension TrackerCreationViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 38
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        trackerTextFiled.becomeFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        trackerTextFiled.resignFirstResponder()
        return true
    }
}

// MARK: - TableView Extenstion

extension TrackerCreationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            tapCategoriesCell()
        default:
            tapScheduleCell()
        }
    }
}

extension TrackerCreationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      //  return dataForTableView.count
        switch trackerType {
        case .regular:
            return 2
        case .irregular:
            return 1
        default: preconditionFailure("Error: Trecker Type")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as? ButtonCell else {
            return UITableViewCell()
        }
        cell.accessoryType = .disclosureIndicator
        cell.label.text = dataForTableView[indexPath.row]
        cell.backgroundColor = .custom.backgroundDay

        if indexPath.row == 0 {
            cell.setup(selectedCategory)
        } else {
            let string = selectedSchedule.map({$0.shortStyle}).joined(separator: ", ")
           
            cell.setup(string)
        }
        return cell
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension TrackerCreationViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case emojisCollectionView:
            return emojies.count
        default:
            return colors.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiAndColorCell", for: indexPath) as?
                EmojiAndColorCell else {return UICollectionViewCell()}
        
        switch collectionView {
        case emojisCollectionView:
            cell.setText(text: emojies[indexPath.row])
            return cell
        default:
            cell.setColor(color: colors[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else {return}
        
        switch collectionView {
        case emojisCollectionView:
            cell.selectedBackgroundView = selectedBackgroundForEmoji
            selectedEmoji = emojies[indexPath.row]
        default:
            selectedBackgroundForColor.layer.borderColor = colors[indexPath.row].cgColor.copy(alpha: 0.3)
            cell.selectedBackgroundView = selectedBackgroundForColor
            selectedColor = colors[indexPath.row]
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else {return}
        cell.selectedBackgroundView = nil
    }
}



// MARK: - TrackerCreationViewController Extension

extension TrackerCreationViewController: ScheduleViewControllerDelegate {
    func createSchedule(schedule: [WeekDay]) {
        self.selectedSchedule = schedule
        let additionalText = selectedSchedule.map {$0.shortStyle}.joined(separator: ", ")
        print("additional Text \(additionalText)")
        self.setScheduleButtonSubTitle(with: additionalText)
        buttonsTableView.reloadData()
    }
}

extension TrackerCreationViewController: CategoriesViewControllerDelegate {
    func selectCategory(_ string: String) {
        self.selectedCategory = string
        self.buttonsTableView.reloadData()
    }
}
