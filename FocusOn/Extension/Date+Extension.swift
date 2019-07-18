//
//  Date+Extension.swift
//  FocusOn
//
//  Created by Rafal Padberg on 11.04.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import Foundation

extension Date {
    
    func getDifferenceOfDaysFromNow(toDate: Date) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let nowArray = formatter.string(from: self).split(separator: "-")
        let dateArray = formatter.string(from: toDate).split(separator: "-")
        
        let num1 = 372 * Int(nowArray[0])! + 31 * Int(nowArray[1])! + Int(nowArray[2])!
        let num2 = 372 * Int(dateArray[0])! + 31 * Int(dateArray[1])! + Int(dateArray[2])!
        return num1 - num2
    }
    
    func getDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: self)
    }
    
    static func firstOfMonth(thisMonthMinus months: Int = 0) -> Date {
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let month = formatter.string(from: today)
        let monthArray = month.split(separator: "-")
        
        var minusArray = [0, months % 12 ?? 0, months / 12 ?? 0]
        var minus: [Int] = [0, 0]
        
        if Int(monthArray[1])! <= minusArray[1] {
            minus[0] = Int(monthArray[1])! + 12 - minusArray[1]
            minus[1] =  Int(monthArray[2])! - minusArray[2] - 1
        } else {
            minus[0] = Int(monthArray[1])! - minusArray[1]
            minus[1] = Int(monthArray[2])! - minusArray[2]
        }
        
        let newDate = formatter.date(from: "01-\(minus[0])-\(minus[1])")
        let firstDayOfTheMonth = Calendar(identifier: .gregorian).startOfDay(for: newDate!)
        return firstDayOfTheMonth
    }
}
