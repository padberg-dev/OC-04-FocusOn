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
    
    // MARK:- Private Properties
    
    private var groupedData: [String : [[GoalData]]] = [:]
    
    private var distinctYears: [String] = []
    private let yearsCategories: [String] = [
        "Jan", "Feb", "Mar", "Apr", "May", "Jun","Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ]
    private let monthsNames: [String] = [
        "Whole Year", "January", "February", "March", "April", "Mai", "June", "July",
        "August", "September", "October", "November", "December"
    ]
    private let colorsTheme: [String] = ["#008481", "#4FA49A", "#93BBAD", "#F1E3D0", "#294D57"]
    
    // MARK:- Public Properties
    
    var activeMonth: Int = 0
    var activeYear: Int = 0
    var isTaskActive: Bool = true
    
    // MARK:- Public Methods
    
    mutating func initialize(with givenData: [GoalData]? = nil) {
        
        if let data = givenData {
            prepareData(withGivenData: data)
        } else {
            prepareData()
        }
        setDistinctiveYears()
    }
    
    func getYearsAndAvailability() -> (names: [String], availability: [Bool]) {
        
        let monthsAvilablility: [Bool] = Array(repeating: true, count: distinctYears.count)
        return (distinctYears, monthsAvilablility)
    }
    
    func getLabelText() -> String {
        
        return "\(activeMonth != 0 ? monthsNames[activeMonth] : "") \(activeYear)"
    }
    
    mutating func getMonthsNamesAndAvailability() -> (names: [String], availability: [Bool]) {
        
        var monthsAvilablility: [Bool] = [true]
        if let currentMonths = groupedData[String(activeYear)] {
            
            currentMonths.forEach {
                monthsAvilablility.append(!$0.isEmpty)
            }
        }
        if !monthsAvilablility[activeMonth] { activeMonth = 0 }
        
        return (monthsNames, monthsAvilablility)
    }
    
    func createGraphModel() -> AAChartModel {
        
        let (data, categories) = prepareModelData()
        let model = AAChartModel()
            .chartType(isTaskActive ? .bar : activeMonth != 0 ? .pie : .area)
            .stacking(.none)
            .animationType(.easeInBack)
            .dataLabelEnabled(false)
            .title("")
            .inverted(activeMonth == 0 && !isTaskActive ? true : false)
            .colorsTheme(colorsTheme)
            .categories(categories)
            .series([
                AASeriesElement()
                    .name(isTaskActive ? "Tasks" : "Goals")
                    .allowPointSelect(false)
                    .data(!isTaskActive && activeMonth != 0 ? createDict(data: data) : data)
                    .toDic()!
                ])
        
        return model
    }
    
    func getGroupedData() -> [String : [[GoalData]]] {
        
        return groupedData
    }
    
    // MARK:- PRIVATE
    // MARK:- Graph Preparation Methods
    
    private func prepareModelData() -> (data: [Int], categories: [String]) {
        
        var data: [Int] = []
        var categories: [String] = []
        
        if activeMonth != 0 {
            data = createMonthGraphData()
            categories = Array(1 ... data.count).map { String($0) }
            while (categories.count < 31) {
                
                categories.append("")
            }
        } else {
            data = createYearGraphData()
            categories = yearsCategories
        }
        return (data, categories)
    }
    
    private func createYearGraphData() -> [Int] {
        
        guard let year = groupedData[String(activeYear)] else { fatalError() }
        
        var array: [Int] = []
        
        if isTaskActive {
            year.forEach { month in
                var tasksCompleted = 0
                month.forEach {
                    tasksCompleted += $0.getNumberOfTaskCompletions()
                }
                array.append(tasksCompleted)
            }
        } else {
            year.forEach { month in
                array.append(month.filter { Int($0.goalCompletion) == 3 }.count)
            }
        }
        return array
    }
    
    private func createMonthGraphData() -> [Int] {
        
        guard let month = groupedData[String(activeYear)]?[activeMonth - 1] else { fatalError() }
        guard let firstDate = month.first?.date else { fatalError() }
        
        let daysInThisMonth = firstDate.daysInMonth()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM YYYY"
        
        var array: [Int]!
        
        if isTaskActive {
            array = Array(repeating: 0, count: daysInThisMonth)
            formatter.dateFormat = "dd"
            month.forEach {
                if let dayInt = Int(formatter.string(from: $0.date!)) {
                    array[dayInt - 1] = $0.getNumberOfTaskCompletions()
                }
            }
        } else {
            array = Array(repeating: 0, count: 5)
            month.forEach { array[Int($0.goalCompletion)] += 1 }
        }
        return array
    }
    
    
    private func createDict(data: [Int]) -> [[Any]] {
        
        let dictOfAny = [
            ["Completed", data[1]],
            ["TwoTHirds", data[2]],
            ["OneThird", data[3]],
            ["NotCompleted", data[0]],
            ["NotYetAchieved", data[4]
            ]
        ]
        return dictOfAny
    }
    
    // MARK:- Custom Methods
    
    private mutating func prepareData(withGivenData data: [GoalData]? = nil) {
        
        let data = data ?? GoalData.loadAllData()
        
        var monthArray: [GoalData] = []
        var monthsArray: [[GoalData]] = Array(repeating: [], count: 12)
        
        var workingYear = ""
        var workingMonth = ""
        
        var i = 0
        let count = data.count
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        data.forEach { goalData in
            
            let array = formatter.string(from: goalData.date!).split(separator: "-").map { String($0) }
            
            if workingYear != String(array[0]) {
                if workingYear != "" {
                    
                    if let month = Int(workingMonth) {
                        
                        monthsArray[month - 1] = monthArray
                        monthArray.removeAll()
                    }
                    groupedData[workingYear] = monthsArray
                    monthsArray = Array(repeating: [], count: 12)
                }
                workingYear = String(array[0])
            }
            
            if workingMonth != String(array[1]) {
                if workingMonth != "" {
                    
                    if let month = Int(workingMonth) {
                        
                        monthsArray[month - 1] = monthArray
                        monthArray.removeAll()
                    }
                }
                workingMonth = String(array[1])
            }
            monthArray.append(goalData)
            
            i += 1
            if count == i {
                
                if let month = Int(workingMonth) {
                    monthsArray[month - 1] = monthArray
                }
                groupedData[workingYear] = monthsArray
            }
        }
    }
    
    private mutating func setDistinctiveYears() {
        
        groupedData.forEach { distinctYears.append($0.key) }
        distinctYears.sort()
        
        if let string = distinctYears.first, let year = Int(string) {
            activeYear = year
        }
    }
}
