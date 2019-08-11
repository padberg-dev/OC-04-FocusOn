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
        bindingDelegate?.updateTaskWith(imageName: goal.tasks[index].completionImageName, taskId: index, completion: goal.tasks[index].completion)
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
        
        bindingDelegate?.updateAllTasksWith(imageNames: getButtonsImageNames(), completions: getTasksCompletions())
    }
    
    func changeGoalToNYA() {
        let progress: Goal.CompletionProgress = .notYetAchieved
        
        bindingDelegate?.updateGoalWith(imageName: "cancel", completion: progress)
    }
    
    private func cleanOverriddenTasks() {
        for i in 0 ..< 3 {
            if goal.tasks[i].completion == .overridden {
                goal.tasks[i].completion = .completed
            }
        }
    }
    
    private func updateGoalImage(isSwitching: Bool = false) {
        bindingDelegate?.updateGoalWith(imageName: getGoalImageName(), completion: getGoalCompletion())
    }
    
    private func getGoalImageName() -> String {
        return goal.completionImageName
    }
    
    private func getGoalCompletion() -> Goal.CompletionProgress {
        return goal.completion
    }
    
    private func getTasksCompletions() -> [Task.CompletionProgress] {
        var completions = [Task.CompletionProgress]()
        goal.tasks.forEach { completions.append($0.completion) }
        return completions
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
    
    // ---------------
    
    // MARK:- Public Properties
    
    weak var bindingDelegate: TodayBindingDelegate?
    
    // MARK:- Public Properties
    
    private var didCheckLastGoal: Bool = false
    
    // MARK:- Public Methods
    
    func checkLastGoalStatus() {
        if didCheckLastGoal { return }
        
        let context = AppDelegate.context
        
        if let lastGoal = GoalData.findLast(in: context) {
            let differenceOfDays = lastGoal.date?.getDifferenceOfDays(to: Date())//.addingTimeInterval(1 * 24 * 3600))
            
            switch differenceOfDays {
            case 0:
                // lastGoal is from today -> Update UI
                startNewGoal(Goal(goalData: lastGoal))
            case -1:
                // lastGoal is from yesterday -> Check if yesterday's goal is .completed
                print("YESTERDAY GOAL -> CHECK IF COMPLETED")
                if lastGoal.goalCompletion == 3 {
                    // lastGoal is .completed -> Start with a new goal
                    print("GOAL COMPLETED -> START ANEW")
                    startNewGoal()
                } else {
                    // Ask User if he wants to continue with not completed goal from yesterday
                    print("ASK USER")
                    bindingDelegate?.shouldContinueWithLastGoal(completion: { [weak self] shouldContinue in
                        print("Should continue: \(shouldContinue)")
                        if shouldContinue {
                            // User wants to continue with lastGoal -> Copy last goal
                            print("COPY OLD GOAL -> UPDATE UI")
                            var goal = Goal(goalData: lastGoal)
                            goal.date = Date()
                            self?.startNewGoal(goal)
                        } else {
                            // User Wants start with new goal
                            print("USER DENIED -> START ANEW")
                            self?.startNewGoal()
                        }
                    })
                }
            default:
                // lastGoal is older than yesterday -> Start with a new goal
                print("NO GOAL YESTERDAY -> START ANEW")
                startNewGoal()
            }
        } else {
            // There is no lastGoal -> Start with a new goal
            print("NO LAST GOAL -> START ANEW")
            startNewGoal()
        }
        didCheckLastGoal = true
    }
    
    // MARK:- PRIVATE
    // MARK:- Custom Methods
    
    private func updateWholeUI(animationType: InitialAnimationType) {
        bindingDelegate?.updateWholeUI(with: self.goal, animationType: animationType)
    }
    
    private func startNewGoal(_ goal: Goal? = nil) {
        self.goal = goal ?? Goal()
        updateWholeUI(animationType: (goal != nil) ? .continueWithOldGoal : .createNewGoal)
    }
}
