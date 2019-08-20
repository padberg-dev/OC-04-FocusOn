//
//  ExtensionUnitTests.swift
//  FocusOnUnitTests
//
//  Created by Rafal Padberg on 20.08.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import XCTest
@testable import FocusOn

class ExtensionUnitTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    // CGFloat return in range
    func testReturnInRange() {
        
        let floats: [CGFloat] = [
            -22.3, 5.1, -1, -15, 3.9, -4.3, 2.3
        ]
        let ranges: [[CGFloat]] = [
            [0, 3],
            [-20, -5],
            [-12, 6]
        ]
        let results: [[CGFloat]] = [
            [0, 3, 0, 0, 3, 0, 2.3],
            [-20, -5, -5, -15, -5, -5, -5],
            [-12, 5.1, -1, -12, 3.9, -4.3, 2.3],
        ]
        
        for i in 0 ..< ranges.count {
            
            let range = ranges[i]
            let rangeResults = results[i]
            
            for (i, float) in floats.enumerated() {
                
                let result = float.returnInRange(minValue: range[0], maxValue: range[1])
                XCTAssert(result == rangeResults[i], "Result of \(result) is not equat to \(rangeResults[i])")
            }
        }
    }
    
    func testGetDifferenceOfDays() {
        
        var dates = [
            Date(),
            Date().addingTimeInterval(-1 * 24 * 3600),
            Date().addingTimeInterval(-5 * 24 * 3600),
            Date().addingTimeInterval(-12 * 24 * 3600),
            Date().addingTimeInterval(4 * 24 * 3600),
        ]
        // Remove first check with all rest days etc.
        let dayDifferences = [
            [1, 5, 12, -4],
            [-1, 4, 11, -5],
            [-5, -4, 7, -9],
            [-12, -11, -7, -16],
            [4, 5, 9, 16]
        ]
        
        for i in 0 ..< dates.count {
            
            let takenDate = dates.remove(at: i)
            
            for j in 0 ..< dates.count {
                
                let result = takenDate.getDifferenceOfDays(to: dates[j])
                XCTAssert(result == dayDifferences[i][j], "Result of \(result) is not equal to \(dayDifferences[i][j])")
            }
            
            dates.insert(takenDate, at: i)
        }
    }
    
    func testDaysInMonth() {
        
        // [ [month, year] ]
        let monthsOfYears: [[Int]] = [
            [02, 2019],
            [02, 2012],
            [02, 1992],
            [02, 2005],
            [08, 2019],
            [02, 2022]
        ]
        let numberOfDays = [
            28, 29, 29, 28, 31, 28
        ]
        let date = Date()
        for (i, monthYears) in monthsOfYears.enumerated() {
            
            let result = date.daysInMonth(monthYears[0], monthYears[1])
            XCTAssert(result == numberOfDays[i], "Number of days(\(result)) in \(monthYears[0])/\(monthYears[1]) should equal to \(numberOfDays[i])")
        }
    }
}
