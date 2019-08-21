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
            return tableView != nil ? tableView.shouldAnimateSliding : true
        }
    }
    var isFirstCellSelected: Bool {
        get {
            return tableView != nil ? tableView.isFirstCellSelected : false
        }
    }
    
    // MARK:- Private Properties
    
    private var historyVM = HistoryViewModel()
    
    // MARK:- View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.config(viewModel: historyVM)
        view.addDiagonalGradient(of: UIColor.Gradients.greenYellowish)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        parent?.navigationItem.title = "FocusOn History"
        tableView.reloadRows(at: [IndexPath(item: 0, section: 0)], with: .left)
    }
}
