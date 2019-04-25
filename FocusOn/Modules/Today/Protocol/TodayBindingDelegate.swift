//
//  TodayBindingDelegate.swift
//  FocusOn
//
//  Created by Rafal Padberg on 28.03.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import Foundation

protocol TodayBindingDelegate: class {
    func updateGoalWith(imageName: String)
    func updateTaskWith(imageName: String, taskId: Int)
    func updateAllTasksWith(imageNames: [String])
    func undoTaskTextChange(text: String, index: Int)
    func undoGoalTextChange(text: String)
    func updateUI(withGoalData goal: Goal)
}
