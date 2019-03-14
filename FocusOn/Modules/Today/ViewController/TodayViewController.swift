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
    
    private func checkGoalCompletion() {
        let imageName = todayVM.getGoalImageName()
        goalCompletionButton.setImage(UIImage(named: imageName), for: .normal)
    }
    
    @IBAction func goalButtonTapped(_ sender: UIButton) {
        let newImageNames = todayVM.changeGoalCompletion()
        checkGoalCompletion()
        for (i, button) in taskCompletionButtons.enumerated() {
            button.changeImage(to: newImageNames[i])
        }
    }
    
    @IBAction func taskButtonTapped(_ sender: CustomCheckButton) {
        if taskTextFields[sender.tag].text != "" {
            let imageName = todayVM.changeTaskCompletion(withId: sender.tag)
            sender.changeImage(to: imageName)
            checkGoalCompletion()
        } else {
            print("No text in the TextField")
        }
    }
    
    @IBAction func printTapped(_ sender: UIButton) {
        print(todayVM.goal)
    }
}
