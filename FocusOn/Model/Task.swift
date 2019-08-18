//
//  Task.swift
//  FocusOn
//
//  Created by Rafal Padberg on 10.03.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import Foundation

struct Task {
    
    enum CompletionProgress {
        case notCompleted
        case overridden
        case completed
    }
    
    var fullDescription: String
    var completion: Task.CompletionProgress {
        didSet {
            changeImageName()
        }
    }
    var completionImageName: String
    
    init(text: String? = nil, completion: Bool? = nil) {
        self.fullDescription = text ?? ""
        let complete = completion ?? false
        self.completion = complete ? .completed : .notCompleted
        self.completionImageName = "empty"
    }
    
    private func transformCompletion(_ value: Bool) -> CompletionProgress {
        return value ? .completed : .notCompleted
    }
    
    mutating func changeImageName() {
        switch completion {
        case .completed: completionImageName = "completed"
        case .overridden: completionImageName = "completed"
        default: completionImageName = "empty"
        }
    }
}
