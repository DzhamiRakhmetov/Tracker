
import UIKit

// MARK: - protocol TrackerCellDelegate

protocol TrackerCellDelegate: AnyObject {
    func completeTracker(_ trackerCell: TrackerCell, id: UUID, at indexPath: IndexPath, isOn: Bool)
    func deleteTracker(at indexPath: IndexPath)
}

// MARK: - final class TrackerCell

final class TrackerCell: UICollectionViewCell {
    
    weak var delegate: TrackerCellDelegate?
    private var isCompletedToday: Bool = false
    private var trackerId: UUID?
    private var indexPath: IndexPath?
    private var selectedDate: Date?
    
    private lazy var trackerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.backgroundColor = .custom.blue
        return view
    }()
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.backgroundColor = .custom.white.withAlphaComponent(0.3)
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    private lazy var trackerNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .custom.white
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var dayCounterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .custom.black
        return label
    }()
    
    private lazy var dayCounterButton: UIButton = {
        let button = UIButton()
        let pointSize = UIImage.SymbolConfiguration(pointSize: 11)
        let image = UIImage(systemName: "AddButton", withConfiguration: pointSize)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 17
        button.layer.masksToBounds = true
        button.tintColor = .custom.white
        button.contentMode = .center
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(increaseDayCounter), for: .touchUpInside)
        return button
    }()
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addContextMenuInteraction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Helpers
    
    func setDoneImage() {
        let doneImage = UIImage(named: "Done")
        dayCounterButton.setImage(doneImage, for: .normal)
        dayCounterButton.backgroundColor = dayCounterButton.backgroundColor?.withAlphaComponent(0.5)
    }
    
    func setPlusImage() {
        let pointSize = UIImage.SymbolConfiguration(pointSize: 11)
        let plusImage = UIImage(systemName: "plus", withConfiguration: pointSize)
        dayCounterButton.setImage(plusImage, for: .normal)
        dayCounterButton.backgroundColor = dayCounterButton.backgroundColor?.withAlphaComponent(1.0)
    }
    
    func setCheckButtonIsEnabled(_ isEnabled: Bool) {
        dayCounterButton.isEnabled = isEnabled
    }
    
    func setDayCounterButton(is: Bool) {
        isCompletedToday ? setDoneImage() : setPlusImage()
    }
    
    func configure(with tracker: Tracker, isCompletedToday: Bool, completedDays: Int, selectedDate: Date, indexPath: IndexPath) {
        trackerId = tracker.id
        self.isCompletedToday = isCompletedToday
        self.selectedDate = selectedDate
        self.indexPath = indexPath
        
        setUpConstraints()
        
        trackerView.backgroundColor = tracker.color
        dayCounterButton.backgroundColor = tracker.color
        dayCounterButton.isHidden = selectedDate > Date()
        
        trackerNameLabel.text = tracker.name
        emojiLabel.text = tracker.emoji
        dayCounterLabel.text = "\(completedDays) \(dayString(for: completedDays))"
        
        let image = isCompletedToday ? setDoneImage() : setPlusImage()
       // setDayCounterButton(is: isCompletedToday)
    
    }
    
    private func dayString(for count: Int) -> String {
        let mod10 = count % 10
        let mod100 = count % 100
        let not10To20 = mod100 < 10 || mod100 > 20
        
        if count == 0 {
            return "дней"
        } else if mod10 == 1 && not10To20 {
            return "день"
        } else if (mod10 >= 2 && mod10 <= 4) && not10To20 {
            return "дня"
        } else {
            return "дней"
        }
    }
    
    
    private func setUpConstraints() {
        [ trackerView, dayCounterLabel, dayCounterButton].forEach {contentView.addSubview($0)}
        [emojiLabel, trackerNameLabel].forEach {trackerView.addSubview($0)}
        
        NSLayoutConstraint.activate([
            trackerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            trackerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            trackerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            trackerView.heightAnchor.constraint(equalToConstant: 90),
            
            emojiLabel.topAnchor.constraint(equalTo: trackerView.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: trackerView.leadingAnchor, constant: 12),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            
            trackerNameLabel.leadingAnchor.constraint(equalTo: trackerView.leadingAnchor, constant: 12),
            trackerNameLabel.trailingAnchor.constraint(equalTo: trackerView.trailingAnchor, constant: -12),
            trackerNameLabel.bottomAnchor.constraint(equalTo: trackerView.bottomAnchor, constant: -12),
            
            dayCounterLabel.topAnchor.constraint(equalTo: trackerView.bottomAnchor, constant: 16),
            dayCounterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            dayCounterLabel.heightAnchor.constraint(equalToConstant: 18),
            
            dayCounterButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            dayCounterButton.topAnchor.constraint(equalTo: trackerView.bottomAnchor, constant: 8),
            dayCounterButton.heightAnchor.constraint(equalToConstant: 34),
            dayCounterButton.widthAnchor.constraint(equalToConstant: 34),
        ])
    }
    
    @objc func increaseDayCounter() {
        guard let trackerId = trackerId, let indexPath = indexPath else {
            assertionFailure("no trackerID")
            return
        }
        dayCounterButton.isEnabled = true
        delegate?.completeTracker(self, id: trackerId, at: indexPath, isOn: isCompletedToday)
    }
}

// MARK: - Extensions

extension TrackerCell: UIContextMenuInteractionDelegate {
    
    func addContextMenuInteraction() {
        let interaction = UIContextMenuInteraction(delegate: self)
        trackerView.addInteraction(interaction)
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        
        let deleteImage = UIImage(systemName: "trash")
        let editImage = UIImage(systemName: "square.and.pencil")
        
        return UIContextMenuConfiguration(actionProvider: { actions in
            return UIMenu(children: [
                UIAction(title: "Редактировать", image: editImage) { [weak self] _ in
                    guard let self = self else { return }
                    //   self.editTracker(cell: self)
                },
                UIAction(title: "Удалить", image: deleteImage, attributes: .destructive) { [weak self] _ in
                    guard let self = self, let indexPath = indexPath else { return }
                    delegate?.deleteTracker(at: indexPath)
                }
            ])
        })
    }
}
