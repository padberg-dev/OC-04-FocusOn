//
//  Task.swift
//  FocusOn
//
//  Created by Rafal Padberg on 10.03.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import Foundation

struct Task {
    
    var description: String
    var completion: CompletionProgress = .notCompleted
    
    init(description: String) {
        self.description = description
    }
}
