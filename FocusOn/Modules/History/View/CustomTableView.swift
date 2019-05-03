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
    
    var indexes: [String] = []
    var indexesSections: [Int] = []
    var rowId = 0
    
    var lastYear: String?
    
    var stopUpdating = false
    
    var historyVM: HistoryViewModel!
    
    var selectedCell: IndexPath?
    
    override func awakeFromNib() {
        delegate = self
        dataSource = self
        
        sectionIndexColor = UIColor.darkGray
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
        let newGoals = historyVM.loadNextData(fromMonth: count - 1, toMonth: count)
        if newGoals.count > 0 {
            goals.append(newGoals)
            setIndex()
            self.insertSections([goals.count - 1], with: .none)
            stopUpdating = false
        }
    }
    
    func setIndex() {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM"
        let indx = formatter.string(from: (goals.last?.last!.date)!)
        
        let array = indx.split(separator: "-")

        if lastYear == nil || "\(array[0])" != lastYear {
            indexes.append("\(array[0])")
            indexesSections.append(rowId)
            lastYear = "\(array[0])"
        }
        indexes.append("\(array[1])")
        indexesSections.append(rowId)
        rowId += 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return goals.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals[section].count
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return indexesSections[index]
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return indexes
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = SectionHeaderView()
        let sectionGoals = goals[section]
        let done = sectionGoals.filter { $0.goalCompletion == 3 }
        
        let date = sectionGoals.first?.date
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM YYYY"
        
        headerView.configureHeader(sectionText: formatter.string(from: date!), completedGoals: done.count, allGoals: sectionGoals.count)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
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
