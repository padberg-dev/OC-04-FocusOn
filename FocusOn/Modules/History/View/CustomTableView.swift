//
//  CustomTableView.swift
//  FocusOn
//
//  Created by Rafal Padberg on 19.04.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import UIKit

class CustomTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var goals: [[GoalData]] = []
    var indexes = ["04"]
    var stopUpdating = false
    
    var historyVM: HistoryViewModel!
    
    var selectedCell: IndexPath?
    
    override func awakeFromNib() {
        delegate = self
        dataSource = self
        
        self.rowHeight = 55.0
        
        print("SCREEN: \(UIScreen.main.bounds.height)")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if stopUpdating { return }
        let contentHeight = scrollView.contentSize.height
        let contentOffset = scrollView.contentOffset.y
        if contentOffset > contentHeight - UIScreen.main.bounds.height * 1.3 {
            loadNextPart()
        }
    }
    
    func loadNextPart() {
        stopUpdating = true
        
        let count = goals.count
        let newGoals = historyVM.loadNextData(fromMonth: count, toMonth: count + 1)
        if newGoals.count > 0 {
            goals.append(newGoals)
            indexes.append("03")
            self.insertSections([goals.count - 1], with: .none)
            stopUpdating = false
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return goals.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals[section].count
    }
    
//    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        return indexes
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as? CustomTableViewCell
        
        let goal = goals[indexPath.section][indexPath.row]
        
        cell?.dateLabel.text = goal.date?.description
        cell?.goalNameLabel.text = goal.goalText
        cell?.goalCompletionLabel.text = decodeCompletion(num: goal.goalCompletion)
        cell?.task1Label.text = goal.taskText1
        cell?.task2Label.text = goal.taskText2
        cell?.task3Label.text = goal.taskText3
        
        cell?.task1CompletionLabel.text = goal.taskCompletion1 ? "completed" : "notCompleted"
        cell?.task2CompletionLabel.text = goal.taskCompletion2 ? "completed" : "notCompleted"
        cell?.task3CompletionLabel.text = goal.taskCompletion3 ? "completed" : "notCompleted"
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let index = selectedCell, index == indexPath {
            selectedCell = nil
        } else {
            selectedCell = indexPath
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "SECTION \(section + 1)"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let index = selectedCell, indexPath == index {
            return 133
        }
        return 55
    }

    private func decodeCompletion(num: Int32) -> String {
        switch num {
        case 1:
            return "oneThird"
        case 2:
            return "twoThirds"
        case 3:
            return "completed"
        case 4:
            return "notCompleted"
        default:
            return "notCompleted"
        }
    }
}
