//
//  UIColor+Extensions.swift
//  Tracker
//
//  Created by Джами on 26.04.2023.
//

import UIKit

extension UIColor {
    static let  whiteDay = UIColor(named: "White.day")
    static let  blue =  UIColor(named: "Blue")
    static let backgroundDay = UIColor(named: "Background.day")
    
}

// отступ в TextField
extension UITextField {
    func indent(size:CGFloat) {
        self.leftView = UIView(frame: CGRect(x: self.frame.minX, y: self.frame.minY, width: size, height: self.frame.height))
        self.leftViewMode = .always
    }
}
