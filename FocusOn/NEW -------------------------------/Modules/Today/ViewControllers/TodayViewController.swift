//
//  TodayViewController.swift
//  FocusOn
//
//  Created by Rafal Padberg on 04.03.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import UIKit

class TodayViewController: UIViewController {
    
    // MARK:- Outlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var messageView: AnimatedMaskView!
    @IBOutlet weak var goalLabelView: AnimatedLabelView!
    @IBOutlet weak var goalBlock: GoalBlockView!
    @IBOutlet weak var completionBlock: CompletionBlockView!
    @IBOutlet weak var tasksLabelView: AnimatedLabelView!
    
    @IBOutlet var taskBlocks: [TaskBlockView]!
    
    // MARK:- Private Properties
    
    private var todayVM: TodayViewModel = TodayViewModel()
    
    private var currentInitialAnimationStage: InitialAnimationStage = .none
    private var activeTaskBlock: TaskBlockView?
    
    // MARK: Public Methods
    
    func didFinishCompletionBlockAnimation() {
        
        switch currentInitialAnimationStage {
        case .second:
            animateInitialGoal(animationStage: .third)
        case .update:
            animateUIAppearing()
            tabBarController?.tabBar.animateAppearing()
        case .finished:
            tabBarController?.tabBar.animateAppearing()
        default:
            break
        }
    }
    
    // MARK:- View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegatesAndParentConnections()
        setupKeyboardObserver()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        parent?.navigationItem.title = "FocusOn Today"
        
        view.addVerticalGradient(of: UIColor.Gradients.greenLight)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        todayVM.checkLastGoalStatus()
    }
    
    // MARK:- PRIVATE
    // MARK:- Custom Methods
    
    private func setupDelegatesAndParentConnections() {
        
        todayVM.bindingDelegate = self
        
        goalBlock.config(parent: self)
        completionBlock.config(parent: self)
        taskBlocks.forEach { $0.config(parent: self) }
    }
    
    private func setupUI() {
        
        tabBarController?.tabBar.alpha = 0
        
        goalLabelView.assign(text: "Goal for the day to focus on:")
        tasksLabelView.assign(text: "3 tasks to achieve that goal:", font: .light)
//        messageView.initialSetup()
    }
    
    // MARK:- Keyboard Handling Methods
    
    private func setupKeyboardObserver() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    private func changeTaskTextField(withId id: Int) {
        
        switch id {
        case 0, 1:
            let taskBlock = taskBlocks[id + 1]
            if taskBlock.taskTextField.text == "" {
                taskBlock.taskTextField.becomeFirstResponder()
            } else {
                scrollView.setContentOffset(.zero, animated: true)
            }
        default:
            scrollView.setContentOffset(.zero, animated: true)
        }
    }
    
    private func moveTaskBlockAboveKeyboard(withOriginY keyboardOriginY: CGFloat) {
        
        if let taskBlockMaxY = activeTaskBlock?.frame.maxY {
            
            // +1 For some extra space between keyboard and active taskbar
            let navBarHeight = (navigationController?.navigationBar.frame.height)! + 2
            let statusBar = UIApplication.shared.statusBarFrame.size.height
            let spaceBetweenKeyboardAndActiveTask = (taskBlockMaxY + navBarHeight + statusBar) - keyboardOriginY
            
            if spaceBetweenKeyboardAndActiveTask > 0 {
                scrollView.setContentOffset(CGPoint(x: 0, y: spaceBetweenKeyboardAndActiveTask), animated: true)
            }
        }
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        
        if let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            moveTaskBlockAboveKeyboard(withOriginY: keyboardRect.origin.y)
        }
    }
    
    // MARK:- Animation Methods
    
    private func animateInitialGoal(animationStage: InitialAnimationStage) {
        
        switch animationStage {
        case .first:
            currentInitialAnimationStage = .first
            goalLabelView.show(animated: true)
            goalBlock.animateAppearing()
            
            taskBlocks.forEach { $0.turn() }
        case .second:
            currentInitialAnimationStage = .second
            completionBlock.animateStart()
            
            taskBlocks.forEach { $0.animateAppearing(duration: 2) }
        case .third:
            tasksLabelView.show(animated: true)
            
            for (i, taskBlock) in taskBlocks.enumerated() {
                taskBlock.turnBack(delayBy: i)
                if i == 2 {
                    currentInitialAnimationStage = .finished
                    didFinishCompletionBlockAnimation()
                }
            }
            currentInitialAnimationStage = .none
        case .update:
            currentInitialAnimationStage = .update
            completionBlock.animateStart()
        default:
            break
        }
    }
    
    private func animateUIAppearing() {
        
        goalLabelView.animateAppearing()
        goalBlock.animateAppearing()
        completionBlock.setNYAButton()
        
        tasksLabelView.animateAppearing()
        taskBlocks.forEach { $0.animateAppearing() }
    }
    
    func changeCompletion() {
        
        if validateTasks() {
            todayVM.changeGoalCompletion()
        } else {
            self.messageView.show(with: .notAllTasksDefined)
        }
    }
    
    func changeCompletionToNYA() {
        
        todayVM.changeGoalToNYA()
    }
    
    
    // -------------------------------------
    
    @IBOutlet weak var topTaskSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomTaskSpaceConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var todayView: UIView!
    
    
    var checkedAlready = false
    var isTodayVCFilledOutCompletely: Bool {
        get {
            let validation = validateGoal() && validateTasks()
            if !validation {
                messageView.show(with: .formNotComplete)
            }
            return validation
        }
    }
    
    // MARK:- Private Attributes
    
    private func validateGoal() -> Bool {
        return goalBlock.goalTextField.text != ""
    }
    
    private func validateTasks(onlyOneTask: Int? = nil) -> Bool {
        if let index = onlyOneTask {
            return taskBlocks[index].taskTextField.text == ""
        } else {
            return taskBlocks.filter { $0.taskTextField.text == "" }.count == 0
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
}

// MARK:- UITextFieldDelegate Methods

extension TodayViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        activeTaskBlock = nil
        if let text = textField.text {
            
            if textField.tag < 3 {
                todayVM.changeTaskText(text, withId: textField.tag)
                if text != "" {
                    taskBlocks[textField.tag].checkBox.show()
                }
            } else {
                if text != "" {
                    todayVM.changeGoalText(text)
                    if currentInitialAnimationStage == .first {
                        animateInitialGoal(animationStage: .second)
                    }
                } else {
                    messageView.show(with: .goalIsEmpty)
                }
            }
        }
        changeTaskTextField(withId: textField.tag)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.tag < 3 {
            activeTaskBlock = taskBlocks[textField.tag]
        }
    }
}

// MARK:- TodayBindingDelegate Methods

extension TodayViewController: TodayBindingDelegate {
    
    func shouldContinueWithLastGoal(completion: @escaping ((Bool) -> Void)) {
        
        let alertController = UIAlertController(title: "Continue", message: "Do you want to continue", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "YES", style: .default) { action in
            print(action)
                        completion(true)
        }
        let noAction = UIAlertAction(title: "NO", style: .cancel) { action in
            print(action)
            
                        completion(false)
        }
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        present(alertController, animated: true) {
            print("completed alert")
        }
        print("HAHAHAHAH")
    }
    
    func updateWholeUI(with goal: Goal, animationType: InitialAnimationType) {
        
        goalBlock.update(with: goal)
        completionBlock.updateProgress(to: goal.completion)
        
        for i in 0 ..< 3 {
            
            taskBlocks[i].changeTask(title: goal.fullDescription, completion: goal.tasks[i].completion)
        }
        
        switch animationType {
            
        case .continueWithOldGoal:
            animateInitialGoal(animationStage: .update)
        case .createNewGoal:
            animateInitialGoal(animationStage: .first)
        }
    }
    
    func changeTask(completion: Task.CompletionProgress, forTaskId taskId: Int) {
        
        taskBlocks[taskId].changeTask(completion: completion, immediately: false)
    }
    
    func changeAllTask(completions: [Task.CompletionProgress]) {
        
        for i in 0 ..< 3 {
            
            taskBlocks[i].changeTask(completion: completions[i])
        }
    }
    
    func toggleNotYetAchieved() {
        
        completionBlock.completionView.toggleNotYetAchieved()
    }
    
    // ------------------------------
    
    func undoTaskTextChange(text: String, index: Int) {
        taskBlocks[index].taskTextField.text = text
    }
    
    func undoGoalTextChange(text: String) {
        goalBlock.goalTextField.text = text
    }
    
    func updateGoalWith(imageName: String, completion: Goal.CompletionProgress) {
        
        completionBlock.completionView.changeTo(progress: completion)
        
        if completion == .completed {
            fireAnimation()
        } else {
            fireBackAnimation()
        }
    }
}
