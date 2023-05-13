//
//  Emoji&ColorCell.swift
//  Tracker
//
//  Created by Джами on 29.04.2023.
//

import UIKit

class EmojiAndColorCell: UICollectionViewCell {
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell() {
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6)
        ])
    }
    
    func setColor(color: UIColor) {
        label.backgroundColor = color
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
    }
    
    func setText(text: String) {
        label.text = text
        label.font = UIFont.systemFont(ofSize: 32)
    }
}
