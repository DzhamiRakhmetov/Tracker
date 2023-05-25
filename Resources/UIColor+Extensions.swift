//
//  UIColor+Extensions.swift
//  Tracker
//
//  Created by Джами on 26.04.2023.
//

import UIKit

extension UIColor {

   static var custom: CustomColor  { return CustomColor()}
    
    struct CustomColor {
        var red: UIColor { return UIColor(named: NameColor.red.rawValue) ?? UIColor.systemRed }
        var blue: UIColor { return UIColor(named: NameColor.blue.rawValue) ?? UIColor.blue }
        var backgroundDay: UIColor { return UIColor(named: NameColor.backgroundDay.rawValue) ?? UIColor.systemBackground }
        var BackgroundNight: UIColor { return UIColor(named: NameColor.BackgroundNight.rawValue) ?? UIColor.systemBackground }
        var lightGray: UIColor { return UIColor(named: NameColor.lightGray.rawValue) ?? UIColor.gray }
        var gray: UIColor { return UIColor(named: NameColor.gray.rawValue) ?? UIColor.gray }
        var white: UIColor { return UIColor(named: NameColor.white.rawValue) ?? UIColor.white }
        var black: UIColor { return UIColor(named: NameColor.black.rawValue) ?? UIColor.black }
        
        var colorSelection1: UIColor { return UIColor(named: SelectionColor.ColorSelection1.rawValue) ?? UIColor.white }
        var colorSelection2: UIColor { return UIColor(named: SelectionColor.ColorSelection2.rawValue) ?? UIColor.white }
        var colorSelection3: UIColor { return UIColor(named: SelectionColor.ColorSelection3.rawValue) ?? UIColor.white }
        var colorSelection4: UIColor { return UIColor(named: SelectionColor.ColorSelection4.rawValue) ?? UIColor.white }
        var colorSelection5: UIColor { return UIColor(named: SelectionColor.ColorSelection5.rawValue) ?? UIColor.white }
        var colorSelection6: UIColor { return UIColor(named: SelectionColor.ColorSelection6.rawValue) ?? UIColor.white }
        var colorSelection7: UIColor { return UIColor(named: SelectionColor.ColorSelection7.rawValue) ?? UIColor.white }
        var colorSelection8: UIColor { return UIColor(named: SelectionColor.ColorSelection8.rawValue) ?? UIColor.white }
        var colorSelection9: UIColor { return UIColor(named: SelectionColor.ColorSelection9.rawValue) ?? UIColor.white }
        var colorSelection10: UIColor { return UIColor(named: SelectionColor.ColorSelection10.rawValue) ?? UIColor.white }
        var colorSelection11: UIColor { return UIColor(named: SelectionColor.ColorSelection11.rawValue) ?? UIColor.white }
        var colorSelection12: UIColor { return UIColor(named: SelectionColor.ColorSelection12.rawValue) ?? UIColor.white }
        var colorSelection13: UIColor { return UIColor(named: SelectionColor.ColorSelection13.rawValue) ?? UIColor.white }
        var colorSelection14: UIColor { return UIColor(named: SelectionColor.ColorSelection14.rawValue) ?? UIColor.white }
        var colorSelection15: UIColor { return UIColor(named: SelectionColor.ColorSelection15.rawValue) ?? UIColor.white }
        var colorSelection16: UIColor { return UIColor(named: SelectionColor.ColorSelection16.rawValue) ?? UIColor.white }
        var colorSelection17: UIColor { return UIColor(named: SelectionColor.ColorSelection17.rawValue) ?? UIColor.white }
        var colorSelection18: UIColor { return UIColor(named: SelectionColor.ColorSelection18.rawValue) ?? UIColor.white }
    }
}

enum NameColor: String {
    case red = "Red"
    case blue = "Blue"
    case backgroundDay = "Background.day"
    case BackgroundNight = "Background.night"
    case lightGray = "LightGray"
    case gray = "Grey"
    case white = "White"
    case black = "Black"
}

enum SelectionColor: String, CaseIterable {
    case ColorSelection1 = "ColorSelection1"
    case ColorSelection2 = "ColorSelection2"
    case ColorSelection3 = "ColorSelection3"
    case ColorSelection4 = "ColorSelection4"
    case ColorSelection5 = "ColorSelection5"
    case ColorSelection6 = "ColorSelection6"
    case ColorSelection7 = "ColorSelection7"
    case ColorSelection8 = "ColorSelection8"
    case ColorSelection9 = "ColorSelection9"
    case ColorSelection10 = "ColorSelection10"
    case ColorSelection11 = "ColorSelection11"
    case ColorSelection12 = "ColorSelection12"
    case ColorSelection13 = "ColorSelection13"
    case ColorSelection14 = "ColorSelection14"
    case ColorSelection15 = "ColorSelection15"
    case ColorSelection16 = "ColorSelection16"
    case ColorSelection17 = "ColorSelection17"
    case ColorSelection18 = "ColorSelection18"
}



// отступ в TextField
extension UITextField {
    func indent(size:CGFloat) {
        self.leftView = UIView(frame: CGRect(x: self.frame.minX, y: self.frame.minY, width: size, height: self.frame.height))
        self.leftViewMode = .always
    }
}

extension Date {
    var startOfDay: Date { Calendar.current.startOfDay(for: self) }
}

