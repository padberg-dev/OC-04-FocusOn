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
    
    // Test app related functions of GoalData class
    
    func findingARecord() {
        
        let result = GoalData.findLast(in: managedObjectContext)
        print("**** find")
        print(result)
    }
    
    
    func testAddingOneRecord() {
        
        findingARecord()
    
        let goal = Goal(text: "test", completion: 0, date: Date(), completions: [true, false, false], strings: ["test1", "Test2", "Test3"])
        let result = goal.updateOrCreateGoalData(currentData: nil, in: managedObjectContext)
        print("**** save")
        print(result)
        try? managedObjectContext.save()
        
        findingARecord()
    }
    
    // Test more complex cases
    
}
