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
   let schedule: [Int]?
}

struct Schedule {
    let value: WeekDay
    let isOn: Bool
}


