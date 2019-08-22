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
    
    // MARK:- Static Methods
    
    static func findLast(in context: NSManagedObjectContext) -> GoalData? {
        
        let request: NSFetchRequest<GoalData> = GoalData.fetchRequest()
        let latest = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [latest]
        request.fetchLimit = 1
        
        do {
            let match = try context.fetch(request)
            if match.count == 1 {
                return match.first
            }
        } catch {
            print("DATABASE ERROR: Error fetching [GoalData]")
        }
        return nil
    }
    
    static func findGoalData(matchingFromDate date: Date, in context: NSManagedObjectContext) -> GoalData? {
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
    
    static func loadAllData(inContext: NSManagedObjectContext? = nil) -> [GoalData] {
        
        var match: [GoalData] = []
        let context = inContext ?? AppDelegate.context
        
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
    
    static func loadLastMonthData() -> [[GoalData]] {
        
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
            match = GoalData.loadNextData(fromMonth: 1, toMonth: 2)
        }
        return [match]
    }
    
    static func loadNextData(fromMonth: Int, toMonth: Int) -> [GoalData] {
        
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
    
    static func deleteData(last number: Int = 0) {
        
        var match: [GoalData] = []
        let context = AppDelegate.context
        
        let request: NSFetchRequest<GoalData> = GoalData.fetchRequest()
        
        if number != 0 {
            let latest = NSSortDescriptor(key: "date", ascending: false)
            request.sortDescriptors = [latest]
            request.fetchLimit = number
        }
        
        do {
            match = try context.fetch(request)
        } catch {
            print("DATABASE ERROR")
        }
        
        match.forEach {
            context.delete($0)
        }
        do {
            try context.save()
        } catch {
            
        }
    }
    
    // CREATORS
    
    static func createYesterdayScenario() {
        
        deleteData(last: 2)
        
        let context = AppDelegate.context
        
        let goal = GoalData(context: context)
        goal.date = Date().addingTimeInterval(-24*3600)
        goal.goalText = GoalData.generateGoalName()
        goal.goalCompletion = Int32(2)
        goal.taskText1 = GoalData.generateTask()
        goal.taskCompletion1 = true
        goal.taskText2 = GoalData.generateTask()
        goal.taskCompletion2 = false
        goal.taskText3 = GoalData.generateTask()
        goal.taskCompletion3 = true
        
        try! context.save()
    }
    
    static func createALotOfDataScenario(numberOfDays: Int) {
        let context = AppDelegate.context
        
        let numberOfDays = numberOfDays - 1
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
            goal.taskText1 = GoalData.generateTask()
            goal.taskCompletion1 = completions[0] == 1 ? true : false
            goal.taskText2 = GoalData.generateTask()
            goal.taskCompletion2 = completions[1] == 1 ? true : false
            goal.taskText3 = GoalData.generateTask()
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
    
    static func generateTask() -> String {
        let tasks = [
            "Order a cake", "Sweep the house", "Get ice cream", "Clean out the fridge", "Buy milk", "Buy coffee", "Buy bananas", "Continue with article", "Purchase new computer", "Read book", "Listen to music", "Write some sentences", "Buy presents", "Get oil changed", "Take photos", "Task1", "Task2", "Taks3", "Do a review", "Write a post", "Email John", "Reasearch Wordpress", "Plan a new project", "Finish knitting", "Brainstorm blog posts", "Plan trip to Rome", "Get mac fixed", "Book tickets to concert", "Find a hotel in London", "Buy a gift", "Book a dentist appointment", "Get a projector", "Take Henry to the airport", "Play chess", "Meet with Samantha", "Go for a run", "Water the plants", "Make dinner reservation", "Order cake", "Buy plane tickets", "Book a hotel", "Pay bills", "Discuss the issues", "Take taekwondo class", "Buy ketchup", "New table", "Yard work", "Clean garage",
        ]
        return tasks.randomElement() ?? "Random task"
    }
}
