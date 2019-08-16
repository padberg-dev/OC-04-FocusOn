//
//  TodayBindingDelegate.swift
//  FocusOn
//
//  Created by Rafal Padberg on 28.03.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import Foundation

protocol TodayBindingDelegate: class {
    func updateGoalWith(imageName: String, completion: Goal.CompletionProgress)
    func undoTaskTextChange(text: String, index: Int)
    func undoGoalTextChange(text: String)
    
    // ----------------
    
    func shouldContinueWithLastGoal(completion: @escaping ((_ shouldContinue: Bool) -> Void))
    func updateWholeUI(with goal: Goal, animationType: InitialAnimationType)
    func changeTask(completion: Task.CompletionProgress, forTaskId taskId: Int)
    func changeAllTask(completions: [Task.CompletionProgress])
}
