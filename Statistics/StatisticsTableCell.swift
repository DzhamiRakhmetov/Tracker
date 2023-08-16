//
//  StatisticsTableCell.swift
//  Tracker
//
//  Created by Dzhami on 12.08.2023.
//

import UIKit

final class StatisticsTableCell: UITableViewCell {
    
    private lazy var cellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.systemBackground
        return view
    }()
    
    private lazy var gradientBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.layer.addSublayer(gradientLayer)
        return view
    }()
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        let gradientSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 90)
        gradient.frame = CGRect(origin: .zero, size: gradientSize)
        gradient.colors = [
            UIColor.custom.firstGradientColor.cgColor,
            UIColor.custom.secondGradientColor.cgColor,
            UIColor.custom.thirdGradientColor.cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.cornerRadius = 16
        gradient.masksToBounds = true
        return gradient
    }()
    
    private lazy var resultTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var resultSubTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        contentView.addSubview(gradientBackgroundView)
        gradientBackgroundView.addSubview(cellView)
        [resultTitle, resultSubTitle].forEach { cellView.addSubview($0) }
        NSLayoutConstraint.activate([
            gradientBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            gradientBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gradientBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            gradientBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            cellView.topAnchor.constraint(equalTo: gradientBackgroundView.topAnchor, constant: 1),
            cellView.leadingAnchor.constraint(equalTo: gradientBackgroundView.leadingAnchor, constant: 1),
            cellView.bottomAnchor.constraint(equalTo: gradientBackgroundView.bottomAnchor, constant: -1),
            cellView.trailingAnchor.constraint(equalTo: gradientBackgroundView.trailingAnchor, constant: -1),
            
            resultTitle.topAnchor.constraint(equalTo: gradientBackgroundView.topAnchor, constant: 12),
            resultTitle.leadingAnchor.constraint(equalTo: gradientBackgroundView.leadingAnchor, constant: 12),
            
            resultSubTitle.leadingAnchor.constraint(equalTo: gradientBackgroundView.leadingAnchor, constant: 12),
            resultSubTitle.bottomAnchor.constraint(equalTo: gradientBackgroundView.bottomAnchor, constant: -12)
        ])
    }
    
    func set(title: String) {
        resultSubTitle.text = title
    }

    func set(value: Int) {
        resultTitle.text = String(value)
    }
}
