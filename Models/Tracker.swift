//
//  Tracker.swift
//  Tracker
//
//  Created by Джами on 27.04.2023.
//

import UIKit

struct Tracker {
    let id : UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule:[WeekDay]
    
    //    init(id: UUID ,name: String, color: UIColor, emoji: String, schedule: [Schedule]) {
    //        self.id = id
    //        self.name = name
    //        self.color = color
    //        self.emoji = emoji
    //        self.schedule = schedule
    //    }
}

struct Schedule {
    let value: WeekDay
    let isOn: Bool
}

enum WeekDay: Int, CaseIterable {
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
    case sunday = 1
    
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
