//
//  TodayViewController.swift
//  FocusOn
//
//  Created by Rafal Padberg on 04.03.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import UIKit

class TodayViewController: UIViewController {

    @IBOutlet weak var goalTextField: UITextField!
    @IBOutlet weak var goalCompletionButton: UIButton!
    
    @IBOutlet var taskCompletionButtons: [UIButton]!
    @IBOutlet var taskTextFields: [UITextField]!
    
    var todayVM: TodayViewModel!
    
    override func awakeFromNib() {
        tabBarItem.image = UIImage(named: "today")
        title = "Today"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        parent?.navigationItem.title = "FocusOn Today"
    }
    
    private func checkGoalCompletion() {
        let status = todayVM.checkGoalStatus()
        goalCompletionButton.setImage(UIImage(named: status), for: .normal)
    }
    
    @IBAction func goalButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func taskButtonTapped(_ sender: UIButton) {
        if taskTextFields[sender.tag].text != "" {
            let status = todayVM.changeTaskCompletion(withId: sender.tag)
            sender.setImage(UIImage(named: status), for: .normal)
            checkGoalCompletion()
        } else {
            print("No text in the TextField")
        }
    }
    
}
