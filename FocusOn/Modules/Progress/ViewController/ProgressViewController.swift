//
//  ProgressViewController.swift
//  FocusOn
//
//  Created by Rafal Padberg on 04.03.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import UIKit

class ProgressViewController: UIViewController {

    override func awakeFromNib() {
        tabBarItem.image = UIImage(named: "progress")
        title = "Progress"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        parent?.navigationItem.title = "FocusOn Progress"
    }
}
