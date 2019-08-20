//
//  CoreDataUnitTests.swift
//  FocusOnUnitTests
//
//  Created by Rafal Padberg on 13.08.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import XCTest
import CoreData
@testable import FocusOn

class CoreDataUnitTests: XCTestCase {
    
    private var managedObjectContext: NSManagedObjectContext!

    override func setUp() {
        
        managedObjectContext = setupCoreDataStack(with: "FocusOn", in: Bundle.main)
    }

    override func tearDown() {
        
        managedObjectContext = nil
    }
    
    // Test functions of GoalData class
    
    func testAddingOneRecord() {
        
        // There should be no record
        let noRecordResult = findingLastRecord()
        XCTAssertNil(noRecordResult, "There should be no GoalData record in the memory")
    
        let goal = Goal(text: "test", completion: 0, date: Date(), completions: [true, false, false], strings: ["test1", "Test2", "Test3"])
        _ = goal.updateOrCreateGoalData(currentData: nil, in: managedObjectContext)
        
        try? managedObjectContext.save()
        
        let firstRecordResult = findingLastRecord()
        XCTAssert(firstRecordResult != nil, "There should be one GoalData record in the memory")
    }
    
    func testAddingMultipleRecords() {
        
        // There should be no record
        let noRecordResult = findingLastRecord()
        XCTAssertNil(noRecordResult, "There should be no GoalData record in the memory")
        
        let completions = [
            [true, false, true],
            [false, false, true],
            [true, true, false],
            [false, false, false],
            [true, true, true]
        ]
        var dates: [Date] = []
        // Add 5 Goals in reverse date order (oldest first)
        for i in 0 ..< 5 {
            
            let date = Date().addingTimeInterval(-Double(i) * 24 * 3600)
            dates.append(date)
            let completion = completions[i].filter { $0 }.count
            
            let goal = Goal(text: "test-\(i)", completion: completion, date: date, completions: completions[i], strings: ["test1", "Test2", "Test3"])
            _ = goal.updateOrCreateGoalData(currentData: nil, in: managedObjectContext)
            
            try? managedObjectContext.save()
        }
        // Get all data in chronological order
        let allGoals = findAllRecords()
        XCTAssert(allGoals.count == 5, "There should be 5 stored Goals")
        
        for i in 0 ..< 5 {
            let oldI = 4  - i
            
            XCTAssert(allGoals[i].date == dates[oldI], "The dates are not the same")
            XCTAssert(allGoals[i].goalText == "test-\(oldI)", "The text of the goal is not the same")
            let oldCompletion = completions[oldI].filter { $0 }.count
            XCTAssert(allGoals[i].goalCompletion == oldCompletion, "Completions should be the same")
        }
    }
    
    // Helper function
    
    func findingLastRecord() -> GoalData? {
        
        return GoalData.findLast(in: managedObjectContext)
    }
    
    func findAllRecords() -> [GoalData] {
        
        return GoalData.loadAllData(inContext: managedObjectContext)
    }
}
