//
//  HistoryViewModel.swift
//  FocusOn
//
//  Created by Rafal Padberg on 05.03.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import Foundation
import CoreData

class HistoryViewModel {
    
    func loadData() -> [[GoalData]] {
        print("LLL Load data")
        var match: [GoalData] = []
        let context = AppDelegate.context
        
        let firstOfMonth = Date.firstOfMonth()
        
        let request: NSFetchRequest<GoalData> = GoalData.fetchRequest()
        let sorting = NSSortDescriptor(key: "date", ascending: false)
        let predicate = NSPredicate(format: "date > %@", firstOfMonth as CVarArg)
        request.predicate = predicate
        request.sortDescriptors = [sorting]
        
        do {
            match = try context.fetch(request)
        } catch {
            print("DATABASE ERROR")
        }
        while (match.isEmpty) {
            match = loadNextData(fromMonth: 1, toMonth: 2)
        }
        return [match]
    }
    
    func loadNextData(fromMonth: Int, toMonth: Int) -> [GoalData] {
        var match: [GoalData] = []
        let context = AppDelegate.context
        
        let firstOfMonth = Date.firstOfMonth(thisMonthMinus: fromMonth)
        let firstOfNextMonth = Date.firstOfMonth(thisMonthMinus: toMonth)
        
        let request: NSFetchRequest<GoalData> = GoalData.fetchRequest()
        let sorting = NSSortDescriptor(key: "date", ascending: false)
        let predicate = NSPredicate(format: "date > %@ AND date < %@", firstOfNextMonth as CVarArg, firstOfMonth as CVarArg)
        request.predicate = predicate
        request.sortDescriptors = [sorting]
        
        do {
            match = try context.fetch(request)
        } catch {
            print("DATABASE ERROR")
        }
        return match
    }
}
