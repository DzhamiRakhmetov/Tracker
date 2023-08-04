
import Foundation

enum WeekDay: String, CaseIterable {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
    
    var number: Int {
        switch self {
        case .monday: return 2
        case .tuesday: return 3
        case .wednesday: return 4
        case .thursday: return 5
        case .friday: return 6
        case .saturday: return 7
        case .sunday: return 1
        }
    }
    
    var shortDay: String {
        let dateFormatter = DateFormatter()
        let weekDays = dateFormatter.shortWeekdaySymbols
        return weekDays?[number - 1] ?? ""
    }
    
    init?(_ value: Int) {
        switch value {
        case 2: self = .monday
        case 3: self = .tuesday
        case 4: self = .wednesday
        case 5: self = .thursday
        case 6: self = .friday
        case 7: self = .saturday
        case 1: self = .sunday
        default: self = .monday
        }
    }
    
    
    var value: String {
        let dateFormatter = DateFormatter()
        let weekDays = dateFormatter.weekdaySymbols
        return weekDays?[number - 1] ?? ""
    }

    static func fromInt(_ intValue: Int) -> WeekDay {
        switch intValue {
        case 1: return .sunday
        case 2: return .monday
        case 3: return .tuesday
        case 4: return .wednesday
        case 5: return .thursday
        case 6: return .friday
        case 7: return .saturday
        default: return .sunday
        }
    }

    static func fromWeekDay(_ weekDay: WeekDay) -> Int {
        switch weekDay {
        case .sunday: return 1
        case .monday: return 2
        case .tuesday: return 3
        case .wednesday: return 4
        case .thursday: return 5
        case .friday: return 6
        case .saturday: return 7
        }
    }
}
