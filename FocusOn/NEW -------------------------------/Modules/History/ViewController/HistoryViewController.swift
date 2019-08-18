//
//  HistoryViewController.swift
//  FocusOn
//
//  Created by Rafal Padberg on 04.03.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    
    // MARK:- Outlets
    
    @IBOutlet weak var tableView: CustomTableView!
    
    // MARK:- Public Properties
    
    var shouldAnimateSliding: Bool {
        get {
            let isScrolledToTop = tableView != nil ? tableView.contentOffset.y == 0 : true
            return isScrolledToTop
        }
    }
    var isFirstCellSelected: Bool {
        get {
            let isCellSelected = tableView != nil ? tableView.selectedCell == IndexPath(item: 0, section: 0) : false
            return isCellSelected
        }
    }
    
    // MARK:- Private Properties
    
    private var historyVM = HistoryViewModel()
    
    // MARK:- View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.goals = historyVM.loadData()
        tableView.historyVM = historyVM
        tableView.setIndex()
        
        tableView.parentConnection = self
        tableView.sectionIndexColor = UIColor.Main.rosin
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        parent?.navigationItem.title = "FocusOn History"
        tableView.reloadRows(at: [IndexPath(item: 0, section: 0)], with: .left)
        
        view.addDiagonalGradient(of: UIColor.Gradients.greenYellowish)
    }
}
