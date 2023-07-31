//
//  ListPresenter.swift
//  ToDoList
//
//  Created by Kurbatov Artem on 29.07.2023.
//

import UIKit
import Foundation

class ListPresenter {
    
    private let userDefaults = UserDefaults.standard
    
    func addTask(_ sourceVC: UIViewController, complition: @escaping ((String) -> Void)) {
        let alert = UIAlertController(title: "Add Task", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "title"
        }
        let addAction = UIAlertAction(title: "Add", style: .cancel) { _ in
            guard let textField = alert.textFields?.first, let text = textField.text else {return}
            complition(text)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        sourceVC.present(alert, animated: true)
    }
    
    func loadTasks() -> [Task] {
        guard let savedData = userDefaults.object(forKey: Identifiers.savedTasks) as? Data else { return [] }
        let decoder = JSONDecoder()
        guard let tasks = try? decoder.decode([Task].self, from: savedData) else { return [] }
        return tasks
    }
    
    func saveTasks(_ tasks: [Task]) {
        let encoder = JSONEncoder()
        guard let encoded = try? encoder.encode(tasks) else { return }
        userDefaults.set(encoded, forKey: Identifiers.savedTasks)
    }
}
