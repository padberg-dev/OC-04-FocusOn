//
//  TodayViewModel.swift
//  FocusOn
//
//  Created by Rafal Padberg on 05.03.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import UIKit
import CoreData

class TodayViewModel {
    
    var blockSaving = false
    var coreDataLoaded: Bool = false {
        didSet {
        }
    }
    var goal: Goal! {
        didSet {
            saveChanges()
        }
    }
    weak var bindingDelegate: TodayBindingDelegate?
    
    func changeTaskText(_ text: String, withId index: Int) {
        if text != "" {
            goal.tasks[index].fullDescription = text
        } else {
            bindingDelegate?.undoTaskTextChange(text: goal.tasks[index].fullDescription, index: index)
        }
    }
    
    func changeGoalText(_ text: String) {
        if text != "" {
            goal.fullDescription = text
        } else {
            bindingDelegate?.undoGoalTextChange(text: goal.fullDescription)
        }
    }
    
    func changeTaskCompletion(withId index: Int) {
        let newCompletion: Task.CompletionProgress = goal.tasks[index].completion == .notCompleted ? .completed : .notCompleted
        goal.tasks[index].completion = newCompletion
        
        updateGoalImage()
        cleanOverriddenTasks()
        bindingDelegate?.updateTaskWith(imageName: goal.tasks[index].completionImageName, taskId: index)
    }
    
    func changeGoalCompletion() {
        let isCompleted = goal.completion == .completed ? true : false
        
        let from: Task.CompletionProgress = isCompleted ? .overridden : .notCompleted
        let to: Task.CompletionProgress = isCompleted ? .notCompleted : .overridden
        
        for i in 0 ..< 3 {
            if goal.tasks[i].completion == from {
                goal.tasks[i].completion = to
            }
        }
        updateGoalImage()
        bindingDelegate?.updateAllTasksWith(imageNames: getButtonsImageNames())
    }
    
    private func cleanOverriddenTasks() {
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
    
    private func saveChanges() {
        if blockSaving { return }
        let context = AppDelegate.context
        let result = GoalData.findGoalData(matchingFromDate: Date(), in: context)
        let editedGoal = self.goal.updateOrCreateGoalData(currentData: result, in: context)
        print("SAVE....")
        do {
            try context.save()
        } catch {
            print("SAVING ERROR")
        }
    }
    
    init(currentGoal: GoalData? = nil) {
        blockSaving = true
        if currentGoal == nil {
            self.goal = Goal()
        } else {
            
            var strings: [String] = []
            strings.append(currentGoal!.taskText1!)
            strings.append(currentGoal!.taskText2!)
            strings.append(currentGoal!.taskText3!)
            var completions: [Bool] = []
            completions.append(currentGoal!.taskCompletion1)
            completions.append(currentGoal!.taskCompletion2)
            completions.append(currentGoal!.taskCompletion3)
            
            self.goal = Goal(text: currentGoal?.goalText, completion: Int(currentGoal!.goalCompletion), date: currentGoal?.date, completions: completions, strings: strings)
            coreDataLoaded = true
        }
        blockSaving = false
    }
    
    static func loadFromCoreData() -> TodayViewModel {
        let context = AppDelegate.context
        let result = GoalData.findLastData(in: context)
        
        if result != nil {
            // Database has at leat one record
            return TodayViewModel(currentGoal: result)
        } else {
            // Empty Database
            return TodayViewModel()
        }
    }
    
    func loadData() {
        blockSaving = true
        for i in 0 ..< 3 {
            goal.tasks[i].changeImageName()
        }
        self.goal.updateGoal()
            bindingDelegate?.updateUI(withGoalData: self.goal)
        blockSaving = false
    }
    
    deinit {
        bindingDelegate = nil
    }
}
