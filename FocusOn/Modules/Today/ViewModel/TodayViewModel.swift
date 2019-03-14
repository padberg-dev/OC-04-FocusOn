//
//  TodayViewModel.swift
//  FocusOn
//
//  Created by Rafal Padberg on 05.03.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import Foundation

struct TodayViewModel {
    
    var goal: String = ""
    var tasks: [Task] = [ Task(description: ""), Task(description: ""), Task(description: "")]
    
    mutating func changeTaskText(_ text: String, withId index: Int) {
        tasks[index].description = text
    }
    
    mutating func changeTaskCompletion(withId index: Int) -> String {
        let newCompletion: CompletionProgress = tasks[index].completion == .notCompleted ? .completed : .notCompleted
        tasks[index].completion = newCompletion
        
        return newCompletion == .completed ? "completed" : "empty"
    }
    
    func checkGoalStatus() -> String {
        var num = 0
        var imageName = ""
        tasks.forEach { task in
            if task.completion == .completed { num += 1 }
        }
        switch num {
        case 1:
            imageName = "120"
        case 2:
            imageName = "240"
        case 3:
            imageName = "done"
        default:
            imageName = "0"
        }
        return imageName
    }
}
