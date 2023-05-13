//
//  ButtonCell.swift
//  Tracker
//
//  Created by Джами on 29.04.2023.
//

import UIKit

 class ButtonCell: UITableViewCell {
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17)
        
        return label
    }()
     
//    lazy var customImage: UIImageView = {
//            let image = UIImageView()
//            image.translatesAutoresizingMaskIntoConstraints = false
//        image.image = UIImage(named: <#T##String#>)
//        
//            return image
//        }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setuUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setuUpViews() {
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            ])
    }
     
     func set(additionalText: String?) {
         if let additionalText = additionalText {
             let paragraphStyle = NSMutableParagraphStyle()
             paragraphStyle.lineSpacing = 2
             let additionalTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.custom.backgroundDay]
             let additionalAttributedString = NSMutableAttributedString(string: additionalText, attributes: additionalTextAttributes)
             additionalAttributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: additionalAttributedString.length))
             label.numberOfLines = 1
             label.attributedText = additionalAttributedString
         } else {
             label.text = nil
         }
     }

}
