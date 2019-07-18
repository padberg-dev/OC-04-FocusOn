//
//  TodayViewController.swift
//  FocusOn
//
//  Created by Rafal Padberg on 04.03.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import UIKit

class TodayViewController: UIViewController, UITextFieldDelegate {
    
    // MARK:- Public Properties
    
    var todayVM: TodayViewModel!
    
    
    // -------------------------------------
    
    
    
    @IBOutlet weak var topTaskSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomTaskSpaceConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var goalTextField: UITextField!
    @IBOutlet weak var goalCompletionButton: UIButton!
    
    @IBOutlet var taskCompletionButtons: [CustomCheckButton]!
    @IBOutlet var taskTextFields: [UITextField]!
    
    @IBOutlet var taskBlocks: [TaskBlockView]!
    @IBOutlet weak var goalBlock: GoalBlockView!
    @IBOutlet weak var completionBlock: CompletionBlockView!
    
    @IBOutlet weak var todayView: UIView!
    
    
    var checkedAlready = false
    var isTodayVCFilledOutCompletely: Bool {
        get {
            return validateGoal() && validateTasks()
        }
    }
    
    // MARK:- Private Attributes
    
    // MARK:- View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("VDL TODAY")
        
        todayVM = TodayViewModel.loadFromCoreData()
        setupDelegatesAndParentConnections()
        
        checkStatus()
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
//                todayVM.loadData()
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
//            checkStatus()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        parent?.navigationItem.title = "FocusOn Today"
        var nav = parent?.navigationController?.navigationBar
//        nav?.barStyle = UIBarStyle.default
//        nav?.tintColor = UIColor.white
        
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.Main.berkshireLace, NSAttributedString.Key.font : UIFont(name: "AvenirNextCondensed-Bold", size: 20)]
        
        parent?.navigationController?.title = "ASD"
        parent?.navigationController?.navigationBar.barTintColor = UIColor.Main.atlanticDeep
        parent?.navigationController?.navigationBar.addSimpleShadow(color: UIColor.Main.rosin, radius: 6.0, opacity: 0.3, offset: .zero)
        parent?.navigationItem.titleView?.tintColor = UIColor.white
        
        
        DispatchQueue.main.async {
            let gradient = CAGradientLayer()
            gradient.frame = self.view.frame
            gradient.colors = UIColor.Gradients.greenLight
            gradient.startPoint = CGPoint(x: 0, y: 0)
            gradient.endPoint = CGPoint(x: 0, y: 1)
            self.view.layer.insertSublayer(gradient, at: 0)
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if let text = textField.text {
            if textField.tag < 3 {
                todayVM.changeTaskText(text, withId: textField.tag)
                if text != "" {
                    taskBlocks[textField.tag].checkBox.show()
                }
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
//            return taskTextFields[index].text != ""
            return taskBlocks[index].taskTextField.text == ""
        } else {
            return taskBlocks.filter { $0.taskTextField.text == "" }.count == 0
//            return (taskTextFields.filter { $0.text == "" }).count == 0
        }
    }
    
    func nYATapped() {
        todayVM.changeGoalToNYA()
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
    
    func taskButtonTapped(buttonTag: Int) {
        todayVM.changeTaskCompletion(withId: buttonTag)
    }
    
    func fireAnimation() {
        self.topTaskSpaceConstraint.constant = -1
        self.bottomTaskSpaceConstraint.constant = -1
        UIView.animate(withDuration: 0.6) {
            self.view.layoutIfNeeded()
        }
    }
    
    func fireBackAnimation() {
        self.topTaskSpaceConstraint.constant = 20
        self.bottomTaskSpaceConstraint.constant = 20
        UIView.animate(withDuration: 0.6) {
            
            self.view.layoutIfNeeded()
        }
    }
    
    // NO NEED
    @IBAction func taskButtonTapped(_ sender: UIButton) {
        if validateTasks(onlyOneTask: sender.tag) {
            todayVM.changeTaskCompletion(withId: sender.tag)
        } else {
            print("No text in the Task-TextField")
        }
    }
    
    @IBAction func printTapped(_ sender: UIButton) {
        nYATapped()
        print(todayVM.goal)
    }
    
    // MARK:- PRIVATE
    // MARK:- Custom Methods
    
    private func setupDelegatesAndParentConnections() {
        
        todayVM.bindingDelegate = self
        
        goalTextField.delegate = self
        taskTextFields.forEach { $0.delegate = self }
        
        taskBlocks.forEach { $0.config(parent: self) }
    }
}

extension TodayViewController: TodayBindingDelegate {
    
    func updateUI(withGoalData goal: Goal) {
        goalTextField.text = goal.fullDescription
        goalCompletionButton.setImage(UIImage(named: goal.completionImageName), for: .normal)
        goalBlock.setCompletion(to: goal.completion)
        goalBlock.changeLabels(title: goal.fullDescription, date: goal.date.getDateString())
        completionBlock.completionView.changeTo(progress: goal.completion)
        
        for i in 0 ..< 3 {
            taskTextFields[i].text = goal.tasks[i].fullDescription
            taskCompletionButtons[i].setImage(UIImage(named: goal.tasks[i].completionImageName), for: .normal)
            taskBlocks[i].taskTextField.text = goal.tasks[i].fullDescription
            let selected = goal.tasks[i].completion != .notCompleted
            taskBlocks[i].checkBox.set(selected: selected, immediately: true)
        }
    }
    
    func undoTaskTextChange(text: String, index: Int) {
        taskTextFields[index].text = text
        taskBlocks[index].taskTextField.text = text
    }
    
    func undoGoalTextChange(text: String) {
        goalTextField.text = text
    }
    
    func updateGoalWith(imageName: String, completion: Goal.CompletionProgress) {
        goalCompletionButton.setImage(UIImage(named: imageName), for: .normal)
        completionBlock.completionView.changeTo(progress: completion)
        goalBlock.setCompletion(to: completion)
        
        if completion == .completed {
            fireAnimation()
        } else {
            fireBackAnimation()
        }
    }
    
    func updateTaskWith(imageName: String, taskId: Int, completion: Task.CompletionProgress) {
        taskCompletionButtons[taskId].changeImage(to: imageName)
        let selected = completion != .notCompleted
        taskBlocks[taskId].checkBox.set(selected: selected)
    }
    
    func updateAllTasksWith(imageNames: [String], completions: [Task.CompletionProgress]) {
        for (i, button) in taskCompletionButtons.enumerated() {
            button.changeImage(to: imageNames[i])
            let selected = completions[i] != .notCompleted
            taskBlocks[i].checkBox.set(selected: selected)
        }
    }
}
