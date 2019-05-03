//
//  HistoryViewController.swift
//  FocusOn
//
//  Created by Rafal Padberg on 04.03.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: CustomTableView!
    
    var items: [String] = []
    
    var historyVM = HistoryViewModel()
    
    override func awakeFromNib() {
        tabBarItem.image = UIImage(named: "history")
        title = "History"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.goals = historyVM.loadData()
        tableView.setIndex()
        tableView.historyVM = historyVM
    }
    
    override func viewWillAppear(_ animated: Bool) {
        parent?.navigationItem.title = "FocusOn History"
        tableView.reloadRows(at: [IndexPath(item: 0, section: 0)], with: .left)
    }
}
