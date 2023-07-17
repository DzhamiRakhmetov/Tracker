//
//  DataManager.swift
//  Tracker
//
//  Created by Джами on 08.05.2023.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    
    var categories: [TrackerCategory] = [
    TrackerCategory(title: "Уборка",
        trackers: [
            Tracker(id: UUID(), name: "Помыть пол",
                color: .custom.colorSelection5,
                emoji: "🙂",
                schedule: [1] // [WeekDay.saturday, WeekDay.sunday]
               ),
            Tracker(id: UUID(), name: "Погладить одежду",
                color: .custom.colorSelection7,
                emoji: "😡",
                schedule: [1])]), //[WeekDay.tuesday, WeekDay.wednesday])]),
    
    TrackerCategory(title: "Учеба",
                    trackers: [
                        Tracker(id: UUID(), name: "Почитать",
                            color: .custom.colorSelection8,
                            emoji: "❤️",
                            schedule: [1])])] //[WeekDay.monday, WeekDay.tuesday])])]
}
