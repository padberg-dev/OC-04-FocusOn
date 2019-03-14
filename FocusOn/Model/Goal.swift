//
//  Goal.swift
//  FocusOn
//
//  Created by Rafal Padberg on 10.03.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import Foundation

struct Goal: CustomStringConvertible {
    
    var description: String {
        print("===")
        print("Goal: '\(fullDescription)' || Completion: \(completion) || Image: \(completionImageName)")
        for task in tasks {
            print("TASK: '\(task.description)' || completion: \(task.completion) || Image: \(task.completionImageName)")
        }
        return "==="
    }
    
    var fullDescription: String
    var tasks: [Task] {
        didSet {
            updateGoal()
        }
    }
    var completion: CompletionProgress
    var completionImageName: String = "0"
    
    init() {
        self.fullDescription = ""
        self.tasks = Array(repeating: Task(), count: 3)
        self.completion = .notCompleted
    }
    
    private mutating func updateGoal() {
        var num = 0
        tasks.forEach { task in
            if task.completion == .completed || task.completion == .overridden { num += 1 }
        }
        switch num {
            case 1:
            completionImageName = "120"
            completion = .oneThird
            case 2:
            completionImageName = "240"
            completion = .twoThirds
            case 3:
            completionImageName = "done"
            completion = .completed
            default:
            completionImageName = "0"
            completion = .notCompleted
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
