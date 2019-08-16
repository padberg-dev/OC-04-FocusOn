//
//  Goal.swift
//  FocusOn
//
//  Created by Rafal Padberg on 10.03.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import Foundation
import CoreData

struct Goal {
    
    enum CompletionProgress: Int {
        case notCompleted = 0
        case oneThird = 1
        case twoThirds = 2
        case completed = 3
        case notYetAchieved = 4
    }
    
//    var description: String {
//        print("===")
//        print("Goal: '\(fullDescription)' || Completion: \(completion) || Image: \(completionImageName) || \(date)")
//        for task in tasks {
//            print("TASK: '\(task.fullDescription)' || completion: \(task.completion) || Image: \(task.completionImageName)")
//        }
//        return "==="
//    }
    
    var date: Date
    var fullDescription: String
    var tasks: [Task] {
        didSet {
            updateGoal()
        }
    }
    var completion: CompletionProgress
    var completionImageName: String = "0"
    
    init(text: String? = nil, completion: Int? = nil, date: Date? = nil, completions: [Bool] = [], strings: [String] = []) {
        self.fullDescription = text ?? ""
        self.completion = CompletionProgress.init(rawValue: completion ?? 0)!
        self.date = date ?? Date()
        var newTasks: [Task] = []
        
        if strings.isEmpty {
            newTasks = Array(repeating: Task(), count: 3)
        } else {
            for i in 0 ..< 3 {
                newTasks.append(Task(text: strings[i], completion: completions[i]))
            }
        }
        self.tasks = newTasks
        self.updateGoal()
    }
    
    init(goalData: GoalData) {
        self.fullDescription = goalData.goalText ?? ""
        self.completion = CompletionProgress.init(rawValue: Int(goalData.goalCompletion)) ?? CompletionProgress.notCompleted
        self.date = goalData.date ?? Date()
        
        self.tasks = [
            Task(text: goalData.taskText1, completion: goalData.taskCompletion1),
            Task(text: goalData.taskText2, completion: goalData.taskCompletion2),
            Task(text: goalData.taskText3, completion: goalData.taskCompletion3)
        ]
    }
    
    func updateOrCreateGoalData(currentData data: GoalData?, in context: NSManagedObjectContext) -> GoalData {
        let goal = data ?? GoalData(context: context)
        goal.date = self.date
        goal.goalText = self.fullDescription
        goal.goalCompletion = Int32(self.completion.rawValue)
        goal.taskText1 = self.tasks[0].fullDescription
        goal.taskCompletion1 = self.tasks[0].completion == .notCompleted ? false : true
        goal.taskText2 = self.tasks[1].fullDescription
        goal.taskCompletion2 = self.tasks[1].completion == .notCompleted ? false : true
        goal.taskText3 = self.tasks[2].fullDescription
        goal.taskCompletion3 = self.tasks[2].completion == .notCompleted ? false : true
        return goal
    }
    
    mutating func updateGoal() {
        var num = 0
        if completion == .notYetAchieved {
            completionImageName = "cancel"
            return
        }
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
                if task.fullDescription == "" {
                    return false
                }
            }
            return true
        }
        return false
    }
}
