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
    var isTodayVCFilledOutCompletely: Bool {
        get {
            return validateGoal() && validateTasks()
        }
    }
    
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
    
    private func validateGoal() -> Bool {
        return goalTextField.text != ""
    }
    
    private func validateTasks(onlyOneTask: Int? = nil) -> Bool {
        if let index = onlyOneTask {
            return taskTextFields[index].text != ""
        } else {
            return (taskTextFields.filter { $0.text == "" }).count == 0
        }
    }
    
    @IBAction func goalButtonTapped(_ sender: UIButton) {
        if validateTasks() {
            if validateGoal() {
                todayVM.changeGoalCompletion()
            } else {
                print("No text in Goal-TextField")
            }
        } else {
            print("No text in at least one of the Task-TextField")
        }
    }
    
    @IBAction func taskButtonTapped(_ sender: CustomCheckButton) {
        if validateTasks(onlyOneTask: sender.tag) {
            todayVM.changeTaskCompletion(withId: sender.tag)
        } else {
            print("No text in the Task-TextField")
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
