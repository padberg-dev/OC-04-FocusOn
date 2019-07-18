//
//  TodayViewModelUnitTest.swift
//  FocusOnUnitTests
//
//  Created by Rafal Padberg on 28.03.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import XCTest
@testable import FocusOn

class TodayViewModelUnitTest: XCTestCase {
    
    var todayVM = TodayViewModel()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testChangingGoalToCompleteAndBack() {
        todayVM.changeGoalCompletion()
        XCTAssert(todayVM.goal.completion == .completed, "Goal should be completed")
        for i in 0 ..< 3 {
            XCTAssert(todayVM.goal.tasks[i].completion == .overridden, "\(i) task should be overridden")
        }
        
        todayVM.changeGoalCompletion()
        XCTAssert(todayVM.goal.completion == .notCompleted, "Goal should not be completed")
        for i in 0 ..< 3 {
            XCTAssert(todayVM.goal.tasks[i].completion == .notCompleted, "\(i) task should be overridden")
        }
    }
    
    func testCustomTaskSwitching() {
        // Task 1 - changed, Task 2 - not changed, Task 3 changed twice
        todayVM.changeTaskCompletion(withId: 0)
        todayVM.changeTaskCompletion(withId: 2)
        todayVM.changeTaskCompletion(withId: 2)
        
        // Goal should be 1/3 and only 1 task completed
        XCTAssert(todayVM.goal.completion == .oneThird, "Goal should be 1/3 completed")
        let assertedCompletion: [Task.CompletionProgress] = [.completed, .notCompleted, .notCompleted]
        for i in 0 ..< 3 {
            XCTAssert(todayVM.goal.tasks[i].completion == assertedCompletion[i], "\(i) task completion should be \(assertedCompletion[i])")
        }
    }
    
    func testCustomCombinedTaskAndGoalSwitching() {
        // Task 2 - changed || 1/3 = 0 - 1 - 0
        todayVM.changeTaskCompletion(withId: 1)
        // Goal changed || 1 = 1 - 1 - 1
        todayVM.changeGoalCompletion()
        // Goal changed || 1/3 = 0 - 1 - 0
        todayVM.changeGoalCompletion()
        // Task 3 - complete || 2/3 = 0 - 1 - 1
        todayVM.changeTaskCompletion(withId: 2)
        // Goal complete || 1 = 1 - 1 - 1
        todayVM.changeGoalCompletion()
        // Task 3 - changed || 2/3 = 1 - 1 - 0
        todayVM.changeTaskCompletion(withId: 2)
        // Goal changed || 1 = 1 - 1 - 1
        todayVM.changeGoalCompletion()
        // Goal changed || 2/3 = 1 - 1 - 0
        todayVM.changeGoalCompletion()
        
        // Task 1 and 2 should be completed and goal 2/3 completed
        let assertedCompletion: [Task.CompletionProgress] = [.completed, .completed, .notCompleted]
        for i in 0 ..< 3 {
            XCTAssert(todayVM.goal.tasks[i].completion == assertedCompletion[i], "\(i) task completion should be \(assertedCompletion[i])")
        }
        XCTAssert(todayVM.goal.completion == .twoThirds, "Goal should be 2/3 completed")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
