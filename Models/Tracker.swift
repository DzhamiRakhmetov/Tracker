//
//  Tracker.swift
//  Tracker
//
//  Created by Джами on 27.04.2023.
//

import UIKit

struct Tracker {
    let id: UUID 
    let name: String
    let color: UIColor
    let emoji: String
 //   let schedule: [WeekDay]
    let schedule: [Int]?
}

struct Schedule {
    let value: WeekDay
    let isOn: Bool
}


enum WeekDay: String, CaseIterable {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
    
    
    var value: String {
        switch self {
        case .monday:
            return "Понедельник"
        case .tuesday:
            return "Вторник"
        case .wednesday:
            return "Среда"
        case .thursday:
            return "Четверг"
        case .friday:
            return "Пятница"
        case .saturday:
            return "Суббота"
        case .sunday:
            return "Воскресенье"
        }
    }


    var shortStyle: String {
        switch self {
        case .monday:
            return "Пн"
        case .tuesday:
            return "Вт"
        case .wednesday:
            return "Ср"
        case .thursday:
            return "Чт"
        case .friday:
            return "Пт"
        case .saturday:
            return "Сб"
        case .sunday:
            return "Вс"
        }
    }
}

final class ScheduleService {
    
    func arrayToString(array: [Int]) -> String {
        let sortedDays = array.sorted()
        let shortNames = sortedDays.map { changeDayToShortName(day: $0) }
        let finalString = shortNames.joined(separator: ", ")

        return finalString
    }
    
    func addDayToSchedule(day: String) -> Int {
        switch day {
        case "Понедельник":
            return 1
        case "Вторник":
            return 2
        case "Среда":
            return 3
        case "Четверг":
            return 4
        case "Пятница":
            return 5
        case "Суббота":
            return 6
        case "Воскресенье":
            return 7
        default:
            return 0
        }
    }
    
    func changeDayToShortName(day: Int) -> String {
        switch day {
        case 1:
            return "Пн" 
        case 2:
            return "Вт"
        case 3:
            return "Ср"
        case 4:
            return "Чт"
        case 5:
            return "Пт"
        case 6:
            return "Cб"
        case 7:
            return "Вс"
        default:
            return ""
        }
    }
}
