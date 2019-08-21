//
//  ProgressViewModelUnitTests.swift
//  FocusOnUnitTests
//
//  Created by Rafal Padberg on 21.08.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import XCTest
import CoreData
@testable import FocusOn

class ProgressViewModelUnitTests: XCTestCase {
    
    private var managedObjectContext: NSManagedObjectContext!
    
    override func setUp() {
        
        managedObjectContext = setupCoreDataStack(with: "FocusOn", in: Bundle.main)
    }
    
    let dateStrings: [String] = [
        "11-02-2017", "18-02-2017", "28-02-2017", "31-03-2017", "06-05-2017",
        "01-01-2018", "31-01-2018", "13-04-2018", "21-04-2018", "22-04-2018", "26-07-2018",
        "03-01-2019", "04-01-2019", "04-06-2019", "20-06-2019", "01-07-2019", "08-08-2019", "27-08-2019"
    ]
    // 3 years [2017, 2018, 2019]
    let numberOfYears = 3
    // Number of days in a year: [2017: 5, 2018: 6, ...] etc.
    let daysInYear: [String : Int] = [
        "2017": 5,
        "2018": 6,
        "2019": 7
    ]
    // For each year number of days in a month: 2017[01: [0, 3, 1, 0, 1, 0, ...] etc.
    let daysForMonthInAYear: [String : [Int]] = [
        "2017": [
            0, 3, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0
        ],
        "2018": [
            2, 0, 0, 3, 0, 0, 1, 0, 0, 0, 0, 0
        ],
        "2019": [
            2, 0, 0, 0, 0, 2, 1, 2, 0, 0, 0, 0
        ],
    ]
    
    func testPrepareData() {
        
        let noRecordResult = GoalData.findLast(in: managedObjectContext)
        XCTAssertNil(noRecordResult, "There should be no GoalData record in the memory")
        
        seedDataIntoMemory()
        
        let allData = GoalData.loadAllData(inContext: managedObjectContext)
        XCTAssertTrue(allData.count == dateStrings.count, "There should be \(dateStrings.count) number of GoalData records, but in memory there is \(allData.count)")
        
        var progressVM = ProgressViewModel()
        progressVM.initialize(with: allData)
        
        // Received data structure: [String : [[GoalData]]]
//        [ "2017" :
//            [
//              //  0-Jan   ,   01-Feb  ,   02-Mar  , ... etc. 12 months
//                [GoalData], [GoalData], [GoalData], ...
//            ],
//          "2018" : ...
//        ]
        let groupedData = progressVM.getGroupedData()
        
        let numOfYears = groupedData.count
        XCTAssertTrue(numOfYears == numberOfYears, "There should be \(numberOfYears) Years of data, but there are \(numOfYears)")
        
        groupedData.forEach { (year: String, data: [[GoalData]]) in
            
            let numberOfAllGoalsInAYear = data.flatMap { $0 }.count
            let expectedNumberOfGoalsInAYear = daysInYear[year] ?? 0
            
            XCTAssertTrue(numberOfAllGoalsInAYear == expectedNumberOfGoalsInAYear, "There should be \(expectedNumberOfGoalsInAYear) GoalData entries in years \(year), but there are \(numberOfAllGoalsInAYear)")
            
            let allMonthsArrayWithNumberOfGoals = data.map { $0.count }
            let expectedAllMonthsWithNumberOfGoals = daysForMonthInAYear[year] ?? Array(repeating: 0, count: 12)
            
            for i in 0 ..< 12 {
                
                let monthCount = allMonthsArrayWithNumberOfGoals[i]
                let expectedMonthCount = expectedAllMonthsWithNumberOfGoals[i]
                let expresion = monthCount == expectedMonthCount
                
                XCTAssertTrue(expresion, "There should be \(expectedMonthCount) of GoalData entries in \(i) month of year \(year), but there are only \(monthCount)")
            }
        }
    }
    
    // MARK:- Helper Methods
    
    private func seedDataIntoMemory() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        
        dateStrings.forEach { dateString in
            
            let date = formatter.date(from: dateString)
            let newGoal = Goal(text: "Test", completion: 0, date: date, completions: [false, false, false], strings: ["1", "2", "3"])
            _ = newGoal.updateOrCreateGoalData(currentData: nil, in: managedObjectContext)
        }
    }
}
