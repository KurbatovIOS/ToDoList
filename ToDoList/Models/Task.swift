//
//  Task.swift
//  ToDoList
//
//  Created by Kurbatov Artem on 29.07.2023.
//

import Foundation

struct Task: Codable {
    let title: String
    var isComplited: Bool = false
}
