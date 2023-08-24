//
//  Filter.swift
//  Tracker
//
//  Created by Dzhami on 13.08.2023.
//

import UIKit

enum Filter: Int, CaseIterable {
    case all, today, completed, uncompleted

    var string: String {
        switch self {
        case .all:
            return "Все трекеры"
        case .today:
            return "Трекеры на сегодня"
        case .completed:
            return "Завершенные"
        case .uncompleted:
            return "Не завершенные"
        }
    }
}
