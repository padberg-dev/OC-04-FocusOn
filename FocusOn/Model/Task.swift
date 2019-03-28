//
//  Task.swift
//  FocusOn
//
//  Created by Rafal Padberg on 10.03.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import Foundation

struct Task {
    
    var fullDescription: String
    var completion: CompletionProgress {
        didSet {
            changeImageName()
        }
    }
    var completionImageName: String
    
    init() {
        self.fullDescription = ""
        self.completion = .notCompleted
        self.completionImageName = "empty"
    }
    
    private mutating func changeImageName() {
        switch completion {
        case .completed: completionImageName = "completed"
        case .overridden: completionImageName = "completed"
        default: completionImageName = "empty"
        }
    }
}
