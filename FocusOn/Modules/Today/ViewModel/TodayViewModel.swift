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
        goal.tasks[index].fullDescription = text
    }
    
    mutating func changeGoalText(_ text: String) {
        goal.fullDescription = text
    }
    
    mutating func changeTaskCompletion(withId index: Int) {
        let newCompletion: CompletionProgress = goal.tasks[index].completion == .notCompleted ? .completed : .notCompleted
        goal.tasks[index].completion = newCompletion
        
        updateGoalImage()
        cleanOverriddenTasks()
        bindingDelegate?.updateTaskWith(imageName: goal.tasks[index].completionImageName, taskId: index)
    }
    
    mutating func changeGoalCompletion() {
        let isCompleted = goal.completion == .completed ? true : false
        
        let from: CompletionProgress = isCompleted ? .overridden : .notCompleted
        let to: CompletionProgress = isCompleted ? .notCompleted : .overridden
        
        for i in 0 ..< 3 {
            if goal.tasks[i].completion == from {
                goal.tasks[i].completion = to
            }
        }
        updateGoalImage()
        bindingDelegate?.updateAllTasksWith(imageNames: getButtonsImageNames())
    }
    
    private mutating func cleanOverriddenTasks() {
        for i in 0 ..< 3 {
            if goal.tasks[i].completion == .overridden {
                goal.tasks[i].completion = .completed
            }
        }
    }
    
    private func updateGoalImage() {
        bindingDelegate?.updateGoalWith(imageName: getGoalImageName())
    }
    
    private func getGoalImageName() -> String {
        return goal.completionImageName
    }
    
    private func getButtonsImageNames() -> [String] {
        var imageNames = [String]()
        goal.tasks.forEach { imageNames.append($0.completionImageName) }
        return imageNames
    }
}
