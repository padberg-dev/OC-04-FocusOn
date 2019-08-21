//
//  HistoryViewModel.swift
//  FocusOn
//
//  Created by Rafal Padberg on 05.03.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import Foundation
import CoreData

class HistoryViewModel {
    
    func loadData() -> [[GoalData]] {
        
        return GoalData.loadLastMonthData()
    }
    
    func loadNextData(fromMonth: Int, toMonth: Int) -> [GoalData] {
        
        return GoalData.loadNextData(fromMonth: fromMonth, toMonth: toMonth)
    }
}
