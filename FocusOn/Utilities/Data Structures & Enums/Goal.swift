//
//  Goal.swift
//  FocusOn
//
//  Created by Rafal Padberg on 10.03.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import Foundation

struct Goal {
    
    var description: String
    var tasks: [Task] = []
    var completion: CompletionProgress = .notCompleted
    
    mutating func addTask(_ taskText: String) {
        if tasks.count < 3 {
            tasks.append(Task(description: taskText))
        } else {
            fatalError("Cannot have more than 3 Tasks per Goal")
        }
    }
    
    mutating func changeTask(_ taskText: String, at index: Int) {
        if index >= tasks.count {
            fatalError("Task with index of '\(index)' does not exist")
        } else {
            tasks[index].description = taskText
        }
    }
    
    private func checkIfCanBeSaved() -> Bool {
        if tasks.count == 3 {
            for task in tasks {
                if task.description == "" {
                    return false
                }
            }
            return true
        }
        return false
    }
}
