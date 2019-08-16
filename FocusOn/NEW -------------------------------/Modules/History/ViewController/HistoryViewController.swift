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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("VDL HISTORY")
        
        tableView.goals = historyVM.loadData()
        tableView.historyVM = historyVM
        tableView.setIndex()
        
        tableView.parentConnection = self
        
        tableView.sectionIndexColor = UIColor.Main.rosin
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        parent?.navigationItem.title = "FocusOn History"
        tableView.reloadRows(at: [IndexPath(item: 0, section: 0)], with: .left)
        
//        DispatchQueue.main.async {
            let gradient = CAGradientLayer()
            gradient.frame = self.view.frame
            gradient.colors = UIColor.Gradients.greenYellowish
            gradient.startPoint = CGPoint(x: 1, y: 0)
            gradient.endPoint = CGPoint(x: 0, y: 1)
            self.view.layer.insertSublayer(gradient, at: 0)
//        }
        
        view.addDiagonalGradient(of: UIColor.Gradients.greenYellowish)
    }
}
