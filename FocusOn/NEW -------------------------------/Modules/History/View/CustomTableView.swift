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
    
    var parentConnection: HistoryViewController!
    
    var lastYear: String?
    var stopUpdating = false
    var historyVM: HistoryViewModel!
    var selectedCell: IndexPath?
    
    override func awakeFromNib() {
        delegate = self
        dataSource = self
        
        register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        
        sectionIndexColor = UIColor.darkGray
        
        rowHeight = UITableView.automaticDimension
        estimatedRowHeight = 60
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
            indexes.append("[\(array[0].suffix(2))]")
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
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as? CustomTableViewCell else { return UITableViewCell() }
        
        let goal = goals[indexPath.section][indexPath.row]
        cell.goal = goal
        
        cell.goalBlockView.setTo(title: goal.goalText!, dateString: goal.date!.getDateString(), completion: decodeCompletion(num: goal.goalCompletion))
        
        cell.taskBlocks[0].changeTaskLabel(goal.taskText1 ?? "")
        cell.taskBlocks[1].changeTaskLabel(goal.taskText2 ?? "")
        cell.taskBlocks[2].changeTaskLabel(goal.taskText3 ?? "")
        
        if selectedCell == indexPath {
            
            cell.taskBlocks.forEach { $0.completeConfig(hasParent: false) }
            cell.taskBlocks[0].checkBox.setAlternative(selected: cell.goal.taskCompletion1)
            cell.taskBlocks[1].checkBox.setAlternative(selected: cell.goal.taskCompletion2)
            cell.taskBlocks[2].checkBox.setAlternative(selected: cell.goal.taskCompletion3)
            
            
            let transform = CGAffineTransform(translationX: 26, y: 0)
            cell.goalBlockView.transform = transform
            cell.gradientView.transform = transform
            cell.gradientViewTop.transform = transform
            cell.gradientViewOverBlock.transform = transform
            cell.gearImageView.transform = CGAffineTransform(rotationAngle: 0.9 * CGFloat.pi)
            cell.goalBlockView.completionImageView.transform = CGAffineTransform(translationX: -26, y: 0)
            cell.bottomConstraint.constant = 100
        } else {
            
            cell.goalBlockView.transform = .identity
            cell.gradientView.transform = .identity
            cell.gradientViewTop.transform = .identity
            cell.gradientViewOverBlock.transform = .identity
            cell.gearImageView.transform = .identity
            cell.goalBlockView.completionImageView.transform = .identity
            cell.bottomConstraint.constant = 0
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let thisCell = cellForRow(at: indexPath) as? CustomTableViewCell else { fatalError() }
        
        beginUpdates()
        
        if selectedCell == nil {
            // Select This Cell
            thisCell.bottomConstraint.constant = 100
            thisCell.cellIsSelected = true
            activateCell(thisCell)
            endUpdates()
        }
        else {
            if selectedCell == indexPath {
                // Deselect This Cell
                thisCell.bottomConstraint.constant = 0
                thisCell.cellIsSelected = false
                deactivateCell(thisCell)
                endUpdates()
            }
            else {
                if let oldCell = cellForRow(at: selectedCell!) as? CustomTableViewCell {
                    // Deselect Old Cell
                    oldCell.bottomConstraint.constant = 0
                    
                    deactivateCell(oldCell) { [weak self] in
                        thisCell.bottomConstraint.constant = 100
                        // Select This Cell
                        self?.activateCell(thisCell)
                        self?.endUpdates()
                    }
                }
                else {
                    thisCell.bottomConstraint.constant = 100
                    // Select This Cell
                    activateCell(thisCell)
                    endUpdates()
                }
            }
        }
        selectedCell = selectedCell == indexPath ? nil : indexPath
    }
    
    private func deactivateCell(_ cell: CustomTableViewCell, completion: (() -> Void)? = nil) {
        
        UIView.animate(withDuration: 0.6, animations: {
            
            cell.goalBlockView.transform = .identity
            cell.gradientView.transform = .identity
            cell.gradientViewTop.transform = .identity
            cell.gradientViewOverBlock.transform = .identity
            cell.gearImageView.transform = .identity
            cell.goalBlockView.completionImageView.transform = .identity
            cell.layoutIfNeeded()
        }) { _ in
            completion?()
        }
    }
    
    private func activateCell(_ cell: CustomTableViewCell) {
        
        cell.taskBlocks.forEach { $0.completeConfig(hasParent: false) }
        cell.taskBlocks[0].checkBox.setAlternative(selected: cell.goal.taskCompletion1)
        cell.taskBlocks[1].checkBox.setAlternative(selected: cell.goal.taskCompletion2)
        cell.taskBlocks[2].checkBox.setAlternative(selected: cell.goal.taskCompletion3)
        
        UIView.animate(withDuration: 0.6, delay: 0.2, options: .curveEaseInOut, animations: {
            
            let transform = CGAffineTransform(translationX: 26, y: 0)
            cell.goalBlockView.transform = transform
            cell.gradientView.transform = transform
            cell.gradientViewTop.transform = transform
            cell.gradientViewOverBlock.transform = transform
            cell.gearImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            cell.goalBlockView.completionImageView.transform = CGAffineTransform(translationX: -26, y: 0)
            cell.layoutIfNeeded()
        }, completion: nil)
    }

    private func decodeCompletion(num: Int32) -> Goal.CompletionProgress {
        switch num {
        case 1:
            return .oneThird
        case 2:
            return .twoThirds
        case 3:
            return .completed
        case 4:
            return .notYetAchieved
        default:
            return .notCompleted
        }
    }
}
