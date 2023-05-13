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

enum WeekDay: String, CaseIterable {
    case monday = "Понедельник"
    case tuesday = "Вторник"
    case wednesday = "Среда"
    case thursday = "Четверг"
    case friday = "Пятница"
    case saturday = "Суббота"
    case sunday = "Воскресенье"
    
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
