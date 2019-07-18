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
    func updateTaskWith(imageName: String, taskId: Int, completion: Task.CompletionProgress)
    func updateAllTasksWith(imageNames: [String], completions: [Task.CompletionProgress])
    func undoTaskTextChange(text: String, index: Int)
    func undoGoalTextChange(text: String)
    func updateUI(withGoalData goal: Goal)
}
