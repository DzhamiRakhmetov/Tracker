//
//  CategoriesViewModelProtocol.swift
//  Tracker
//
//  Created by Dzhami on 07.08.2023.
//

import Foundation

protocol CategoriesViewModelProtocol {
    var delegate: CategoriesViewModelDelegate? { get set }
    func viewDidLoad()
    func setCategory(category: String?)
    func deleteCategory(at indexPath: IndexPath)
//    func setCategory(category: TrackerCategory?)
//    func deleteCategory(category: TrackerCategory)
    func changeCategoryName(at indexPath: IndexPath, to newName: String)
    func editCategory(at indexPath: IndexPath)
}
