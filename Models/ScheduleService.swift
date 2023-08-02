//
//  ScheduleService.swift
//  Tracker
//
//  Created by Dzhami on 27.07.2023.
//

import Foundation

final class ScheduleService {
    
    func arrayToString(array: [WeekDay]) -> String {
        let shortNames = array.map { $0.shortDay }
        let finalString = shortNames.joined(separator: ", ")
        return finalString
    }
    
    func arrayToString(array: [Int]) -> String {
        let weekDays = array.compactMap({ WeekDay($0) })
        let shortNames = weekDays.map { $0.shortDay }
        let finalString = shortNames.joined(separator: ", ")
        return finalString
    }
}
