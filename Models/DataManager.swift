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
    TrackerCategory(
        title: "Уборка",
        trackers: [
        Tracker(id: UUID(),
                name: "Помыть пол",
                color: .custom.colorSelection5,
                emoji: "🙂",
                schedule: [WeekDay.saturday, WeekDay.sunday]
               ),
        Tracker(id: UUID(),
                name: "Погладить одежду",
                color: .custom.colorSelection7,
                emoji: "",
                schedule: [WeekDay.tuesday, WeekDay.wednesday])])]
    
}
