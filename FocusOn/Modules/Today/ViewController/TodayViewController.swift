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
    
    var checkedAlready = false
    
    var todayVM: TodayViewModel!
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
        
        todayVM.loadData()
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.ReferenceType.default
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let strDate = formatter.string(from: Date())
        print(strDate)
        
        print(Date())
    }
    
    private func checkStatus() {
        let locale = Locale(identifier: "pl_PL")
        let date = todayVM.goal.date
        let today = Date()
        
        checkedAlready = true
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if formatter.string(from: date) == formatter.string(from: today) {
            // CONTINUE
            print("CONTINUE!!!")
            todayVM.loadData()
        } else {
            if todayVM.goal.completion == .completed {
                // COREDATA->START NEW
                todayVM.loadData()
            } else {
                // ASK IF LEAVE IT FOR TODAY IF YESTERDAY
                let yesterday = Date().addingTimeInterval(-24*60*60)
                if formatter.string(from: date) == formatter.string(from: yesterday) {
                    print("ASK IF WANT TO CONTINUE WITH YESTERDAYS TASK")
                    
                    let alertController = UIAlertController(title: "Want to continue?", message: "Do you want to continue with this goal today?", preferredStyle: .alert)
                    let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                        self.changeToToday()
                    }
                    let noAction = UIAlertAction(title: "No", style: .cancel) { (action) in
                        self.startAnew()
                    }
                    alertController.addAction(yesAction)
                    alertController.addAction(noAction)
                    present(alertController, animated: true) {
                    }
                }
            }
        }
    }
    
    func changeToToday() {
        todayVM.goal.date = Date()
    }
    
    func startAnew() {
//        todayVM.bindingDelegate = nil
        todayVM = TodayViewModel()
        todayVM.bindingDelegate = self
        todayVM.loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !checkedAlready {
            checkStatus()
        }
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
    
    func updateUI(withGoalData goal: Goal) {
        goalTextField.text = goal.fullDescription
        goalCompletionButton.setImage(UIImage(named: goal.completionImageName), for: .normal)
        
        for i in 0 ..< 3 {
            taskTextFields[i].text = goal.tasks[i].fullDescription
            taskCompletionButtons[i].setImage(UIImage(named: goal.tasks[i].completionImageName), for: .normal)
        }
    }
    
    func undoTaskTextChange(text: String, index: Int) {
        taskTextFields[index].text = text
    }
    
    func undoGoalTextChange(text: String) {
        goalTextField.text = text
    }
    
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
