//
//  HistoryViewController.swift
//  FocusOn
//
//  Created by Rafal Padberg on 04.03.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var items: [String] = []
    
    var historyVM = HistoryViewModel()
    
    override func awakeFromNib() {
        tabBarItem.image = UIImage(named: "history")
        title = "History"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        for i in 0 ... 100 {
            items.append("Number \(i)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        parent?.navigationItem.title = "FocusOn History"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell")
        cell?.textLabel?.text = items[indexPath.row]
        
        return cell!
    }
}
