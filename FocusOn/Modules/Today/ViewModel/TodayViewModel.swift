//
//  TodayViewModel.swift
//  FocusOn
//
//  Created by Rafal Padberg on 05.03.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import Foundation

struct TodayViewModel {
    
    var goal: Goal = Goal()
    weak var bindingDelegate: TodayBindingDelegate?
    
    mutating func changeTaskText(_ text: String, withId index: Int) {
        goal.tasks[index].description = text
    }
    
    mutating func changeGoalText(_ text: String) {
        goal.fullDescription = text
    }
    
    mutating func changeTaskCompletion(withId index: Int) -> String {
        let newCompletion: CompletionProgress = goal.tasks[index].completion == .notCompleted || goal.tasks[index].completion == .overridden ? .completed : .notCompleted
        goal.tasks[index].completion = newCompletion
        
        return goal.tasks[index].completionImageName
    }
    
    mutating func changeGoalCompletion() -> [String] {
        let isCompleted = goal.completion == .completed ? true : false
        
        let from: CompletionProgress = isCompleted ? .overridden : .notCompleted
        let to: CompletionProgress = isCompleted ? .notCompleted : .overridden
        
        for i in 0 ..< 3 {
            if goal.tasks[i].completion == from {
                goal.tasks[i].completion = to
            }
        }
        return getButtonsImageNames()
    }
    
    func getGoalImageName() -> String {
        return goal.completionImageName
    }
    
    private func getButtonsImageNames() -> [String] {
        var imageNames = [String]()
        goal.tasks.forEach { imageNames.append($0.completionImageName) }
        return imageNames
    }
}
