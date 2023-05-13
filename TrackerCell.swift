//
//  TrackerCell.swift
//  Tracker
//
//  Created by Джами on 08.05.2023.
//

import UIKit

protocol TrackerCellDelegate: AnyObject {
    func completeTracker(id: UUID, at indexPath: IndexPath)
    func uncompleteTracher(id: UUID, at indexPath: IndexPath)
}

final class TrackerCell: UICollectionViewCell {
    
    weak var delegate: TrackerCellDelegate?
    private var isCompletedToday: Bool = false
    private var trackerId: UUID?
    private var indexPath: IndexPath?
    
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
    
    private let plusImage: UIImage = {
        let pointSize = UIImage.SymbolConfiguration(pointSize: 11)
        let image = UIImage(systemName: "plus", withConfiguration: pointSize) ?? UIImage()
        return image
    }()
    
    private let doneImage = UIImage(named: "Done")
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Helpers
    func configure(with tracker: Tracker, isCompletedToday: Bool, indexPath: IndexPath) {
        self.trackerId = tracker.id
        self.isCompletedToday = isCompletedToday
        self.indexPath = indexPath
        
        let color = tracker.color
        setUpConstraints()
        
        trackerView.backgroundColor = color
        dayCounterButton.backgroundColor = color
        
        trackerNameLabel.text = tracker.name
        emojiLabel.text = tracker.emoji
        dayCounterLabel.text = "День"
        
        let image = isCompletedToday ? doneImage : plusImage
        dayCounterButton.setImage(image, for: .normal)
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
        if isCompletedToday {
            delegate?.uncompleteTracher(id: trackerId, at: indexPath)
        } else {
            delegate?.completeTracker(id: trackerId, at: indexPath)
        }
    }
}
