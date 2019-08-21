//
//  Date+Extension.swift
//  FocusOn
//
//  Created by Rafal Padberg on 11.04.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import Foundation

extension Date {
    
    func getDifferenceOfDays(to date: Date) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let fromArray = formatter.string(from: self).split(separator: "-")
        let toArray = formatter.string(from: date).split(separator: "-")
        
        let fromNumber = 372 * Int(fromArray[0])! + 31 * Int(fromArray[1])! + Int(fromArray[2])!
        let toNumber = 372 * Int(toArray[0])! + 31 * Int(toArray[1])! + Int(toArray[2])!
        return fromNumber - toNumber
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
        
        var minusArray = [0, months % 12, months / 12]
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
    
    func daysInMonth(_ monthNumber: Int? = nil, _ year: Int? = nil) -> Int {
        var dateComponents = DateComponents()
        dateComponents.year = year ?? Calendar.current.component(.year,  from: self)
        dateComponents.month = monthNumber ?? Calendar.current.component(.month,  from: self)
        if
            let d = Calendar.current.date(from: dateComponents),
            let interval = Calendar.current.dateInterval(of: .month, for: d),
            let days = Calendar.current.dateComponents([.day], from: interval.start, to: interval.end).day
        { return days } else { return -1 }
    }
}
