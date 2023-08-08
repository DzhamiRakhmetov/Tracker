//
//  Extension + String.swift
//  Tracker
//
//  Created by Dzhami on 08.08.2023.
//

import Foundation

extension String {
    func localized() -> String {
        NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
    }
}
