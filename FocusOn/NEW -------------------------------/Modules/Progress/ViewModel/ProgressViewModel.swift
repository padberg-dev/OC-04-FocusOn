//
//  ProgressViewModel.swift
//  FocusOn
//
//  Created by Rafal Padberg on 05.03.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import Foundation
import CoreData

struct ProgressViewModel {
    
    func loadData() -> [GoalData] {
        var match: [GoalData] = []
        let context = AppDelegate.context
        
        let request: NSFetchRequest<GoalData> = GoalData.fetchRequest()
        let sorting = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [sorting]
        
        do {
            match = try context.fetch(request)
        } catch {
            print("DATABASE ERROR")
        }
        return match
    }
}
