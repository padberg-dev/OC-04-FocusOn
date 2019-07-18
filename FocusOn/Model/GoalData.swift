//
//  GoalData.swift
//  FocusOn
//
//  Created by Rafal Padberg on 10.03.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import Foundation
import CoreData

class GoalData: NSManagedObject {
    
//    static func fetchRequest() -> NSFetchRequest<GoalData> {
//        return NSFetchRequest<GoalData>(entityName: "GoalData")
//    }
//    
//    var date: Date = Date()
//    var goalText: String = ""
//    var goalCompletion: Int = 0
//    var taskText1: String = ""
//    var taskCompletion1: Bool = false
//    var taskText2: String = ""
//    var taskCompletion2: Bool = false
//    var taskText3: String = ""
//    var taskCompletion3: Bool = false
    
    static func findGoalData(matchingFromDate date: Date, in context: NSManagedObjectContext) -> GoalData?
    {
        let dateFrom = Calendar(identifier: .gregorian).startOfDay(for: date)
        
        let request: NSFetchRequest<GoalData> = GoalData.fetchRequest()
        request.predicate = NSPredicate(format: "date > %@", dateFrom as NSDate)
        request.fetchLimit = 1
        
        var match: [GoalData] = []
        do {
            match = try context.fetch(request)
        } catch {
            print("DATABASE ERROR")
        }
        
        if match.count == 1 {
            return match[0]
        }
        return nil
    }
    
    static func findLastData(in context: NSManagedObjectContext) -> GoalData?
    {
        let request: NSFetchRequest<GoalData> = GoalData.fetchRequest()
        let latest = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [latest]
        request.fetchLimit = 1
        
        var match: [GoalData] = []
        do {
            match = try context.fetch(request)
        } catch {
            print("DATABASE ERROR")
        }
        
        if match.count == 1 {
            return match[0]
        }
        return nil
    }
    
    static func createYesterdayScenario() {
        let context = AppDelegate.context
        
        let today = Calendar(identifier: .gregorian).startOfDay(for: Date())
        let yesterday = Calendar(identifier: .gregorian).startOfDay(for: Date().addingTimeInterval(-24*3600))
        
        let first = findGoalData(matchingFromDate: today, in: context)
        let second = findGoalData(matchingFromDate: yesterday, in: context)
        if first != nil {
            context.delete(first!)
        }
        if second != nil {
            context.delete(second!)
        }
        
        let goal = GoalData(context: context)
        goal.date = Date().addingTimeInterval(-24*3600)
        goal.goalText = "Yesterday's Goal"
        goal.goalCompletion = Int32(2)
        goal.taskText1 = "First Task"
        goal.taskCompletion1 = true
        goal.taskText2 = "Second Task"
        goal.taskCompletion2 = false
        goal.taskText3 = "Third Task"
        goal.taskCompletion3 = true
        
        try! context.save()
    }
    
    static func createALotOfDataScenario(numberOfDays: Int) {
        let context = AppDelegate.context
        
        for i in 0 ... numberOfDays {
            let goal = GoalData(context: context)
            let completions = GoalData.generateCompletion()
            
            var completionsSum = completions.filter { $0 == 1 }.count
            
            if completionsSum == 3 {
                let oneInEight = Int.random(in: 0 ... 7)
                completionsSum = oneInEight == 7 ? 4 : 3
            }
            
            goal.date = Date().addingTimeInterval(Double(numberOfDays - i) * -24*3600)
            goal.goalText = GoalData.generateGoalName()
            goal.goalCompletion = Int32(completionsSum)
            goal.taskText1 = "First Task"
            goal.taskCompletion1 = completions[0] == 1 ? true : false
            goal.taskText2 = "Second Task"
            goal.taskCompletion2 = completions[1] == 1 ? true : false
            goal.taskText3 = "Third Task"
            goal.taskCompletion3 = completions[2] == 1 ? true : false
        }
        
        try! context.save()
    }
    
    static var lastId: Int = 0
    
    static func generateGoalName() -> String {
        let goalNames = [
            "Learn playing Piano",
            "Prepare meal",
            "Do sport today",
            "Prepare for exams",
            "Fix car issues",
            "Stay healthy",
            "Daily sport",
            "Mock up History VC",
            "Go out with a dog",
            "Transfer money",
            "Buy Cycling equipment",
            "Read some Books",
            "Learn to dance",
            "Finish Xbox game",
            "Repair window",
            "Clean the dishes",
            "Run in a marathon",
            "Write a novel",
            "Hack NASA",
        ]
        var random = 0
        repeat {
            random = Int.random(in: 0 ..< goalNames.count)
        } while (random == GoalData.lastId)
        return goalNames[random]
    }
    
    static func generateCompletion() -> [Int] {
        let random1 = Int.random(in: 0 ... 5) >= 1 ? 1 : 0
        let random2 = Int.random(in: 0 ... 5) >= 1 ? 1 : 0
        let random3 = Int.random(in: 0 ... 5) >= 1 ? 1 : 0
        return [random1, random2, random3]
    }
    
    func getNumberOfTaskCompletions() -> Int {
        var number = taskCompletion1 ? 1 : 0
        number += taskCompletion2 ? 1 : 0
        number += taskCompletion3 ? 1 : 0
        return number
    }
}
