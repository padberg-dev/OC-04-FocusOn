//
//  TodayViewController.swift
//  FocusOn
//
//  Created by Rafal Padberg on 04.03.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import UIKit

class TodayViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var goalTextField: UITextField!
    @IBOutlet weak var goalCompletionButton: UIButton!
    
    @IBOutlet var taskCompletionButtons: [CustomCheckButton]!
    @IBOutlet var taskTextFields: [UITextField]!
    
    var todayVM = TodayViewModel()
    
    override func awakeFromNib() {
        tabBarItem.image = UIImage(named: "today")
        title = "Today"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todayVM.bindingDelegate = self
        goalTextField.delegate = self
        taskTextFields.forEach { $0.delegate = self }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        parent?.navigationItem.title = "FocusOn Today"
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if let text = textField.text {
            if taskTextFields.contains(textField) {
                todayVM.changeTaskText(text, withId: textField.tag)
            } else {
                todayVM.changeGoalText(text)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func goalButtonTapped(_ sender: UIButton) {
        todayVM.changeGoalCompletion()
    }
    
    @IBAction func taskButtonTapped(_ sender: CustomCheckButton) {
        if taskTextFields[sender.tag].text != "" {
            todayVM.changeTaskCompletion(withId: sender.tag)
        } else {
            print("No text in the TextField")
        }
    }
    
    @IBAction func printTapped(_ sender: UIButton) {
        print(todayVM.goal)
    }
}

extension TodayViewController: TodayBindingDelegate {
    
    func updateGoalWith(imageName: String) {
        goalCompletionButton.setImage(UIImage(named: imageName), for: .normal)
    }
    
    func updateTaskWith(imageName: String, taskId: Int) {
        taskCompletionButtons[taskId].changeImage(to: imageName)
    }
    
    func updateAllTasksWith(imageNames: [String]) {
        for (i, button) in taskCompletionButtons.enumerated() {
            button.changeImage(to: imageNames[i])
        }
    }
}
