//
//  TaskBlockView.swift
//  FocusOn
//
//  Created by Rafal Padberg on 20.06.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import UIKit

class TaskBlockView: UIView {
    
    // MARK:- Outlets
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var insideView: UIView!
    @IBOutlet weak var insideBGView: UIView!
    @IBOutlet weak var numberImageView: UIImageView!
    @IBOutlet weak var checkBox: TaskCheckButtonView!
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var taskLabel: UILabel!
    
    @IBOutlet weak var topLine: UIView!
    @IBOutlet weak var bottomLine: UIView!
    
    // MARK:- Public Properties
    
    var parentConnection: TodayViewController!
    
    // MARK:- Private Properties
    
    private var animationDuration: Double = 0.4
    
    // MARK:- Initializers
    
    override func awakeFromNib() {
        
        loadFromNib()
    }
    
    // MARK:- Public Methods
    
    func changeTaskLabel(_ title: String) {
        
        taskLabel.text = title
    }
    
    func changeTask(title: String? = nil, completion: Task.CompletionProgress, immediately: Bool = true) {
        
        let isSelected = completion != .notCompleted
        
        taskTextField.text = title ?? taskTextField.text
        checkBox.set(selected: isSelected, immediately: immediately)
    }
    
    func turn() {
        
        let transform3 = CATransform3D.transform(angleInDeggres: 180, xAxis: true)
        
        self.insideView.subviews.forEach { $0.alpha = 0 }
        self.insideView.layer.cornerRadius = 12
        self.insideView.layer.borderColor = UIColor.Main.rosin.cgColor
        self.insideView.layer.borderWidth = 1.0
        self.insideView.layer.transform = transform3
    }
    
    func turnBack(delayBy: Int) {
        
        let transform = CATransform3D.transform(angleInDeggres: 90, xAxis: true)
        let transform2 = CATransform3D.transform(angleInDeggres: 0, xAxis: true)
        
        UIView.animate(withDuration: self.animationDuration * 2, delay: Double(delayBy) * 0.2, options: .curveEaseInOut, animations: {
            self.insideView.layer.transform = transform
        }, completion: { [weak self] _ in
            self?.insideView.subviews.forEach { $0.alpha = 1 }
            
            self?.insideView.layer.cornerRadius = 0
            self?.insideView.layer.borderWidth = 0.0
            
            UIView.animate(withDuration: self!.animationDuration * 2) {
                self?.insideView.layer.transform = transform2
            }
        })
    }
    
    func activateTextField(isSelected: Bool, immediately: Bool = false) {
        
        if immediately {
            taskTextField.backgroundColor = UIColor.white.withAlphaComponent(isSelected ?  0.1 : 1)
            insideBGView.backgroundColor = UIColor.Main.berkshireLace.withAlphaComponent(isSelected ? 0.15 : 0.5)
        } else {
            UIView.animate(withDuration: animationDuration) {
                self.taskTextField.backgroundColor = UIColor.white.withAlphaComponent(isSelected ?  0.1 : 1)
                self.insideBGView.backgroundColor = UIColor.Main.berkshireLace.withAlphaComponent(isSelected ? 0.15 : 0.5)
            }
        }
    }
    
    func config(parent: TodayViewController?) {
        
        // No parent will be in historyVC
        if parent != nil {
            
            parentConnection = parent
            taskTextField.delegate = parent
            checkBox.parentConnection = self
            alpha = 0
            
            completeConfig(hasParent: true)
        }
    }
    
    func completeConfig(hasParent: Bool) {
        
        var index = self.tag
        
        taskTextField.tag = index
        taskTextField.isHidden = !hasParent
        taskLabel.isHidden = hasParent
        checkBox.checkButton.tag = index
        
        topLine.backgroundColor = UIColor.Main.rosin
        bottomLine.backgroundColor = UIColor.Main.rosin
        
        insideView.addSimpleShadow(color: UIColor.Main.atlanticDeep, radius: 8.0, opacity: !hasParent ? 0.1 :0.4, offset: CGSize(width: 0, height: -2))
        insideBGView.backgroundColor = UIColor.Main.berkshireLace.withAlphaComponent(!hasParent ? 1 : 0.5)
        
        numberImageView.image = UIImage(named: "\(index + 1)")
        
        index += index == 0 && !hasParent ? 1 : 0
        
        DispatchQueue.main.async {
            self.assignCornerRadius(for: index)
        }
    }
    
    func changeImage(toFilled: Bool, immediate: Bool) {
        
        if immediate {
            UIView.animate(withDuration: 2.0) {
                self.numberImageView.image = UIImage(named: "\(self.tag + 1)\(toFilled ? "filled" : "")")
            }
        } else {
            let newImageView = UIImageView(frame: numberImageView.frame)
            newImageView.image = UIImage(named: "\(self.tag + 1)\(toFilled ? "filled" : "")")
            newImageView.alpha = 0
            
            insideView.addSubview(newImageView)
            UIView.animate(withDuration: animationDuration, animations: {
                newImageView.alpha = 1
                self.numberImageView.alpha = 0
            }) { [weak self] _ in
                self?.numberImageView.image = UIImage(named: "\(self!.tag + 1)\(toFilled ? "filled" : "")")
                self?.numberImageView.alpha = 1
                newImageView.removeFromSuperview()
            }
        }
    }
    
    func validateTask() -> Bool {
        
        return taskTextField.text != ""
    }
    
    // MARK:- PRIVATE
    // MARK:- Custom Methods
    
    private func assignCornerRadius(for index: Int) {
        
        var corners: UIRectCorner = []
        
        if index == 0 {
            corners = [.topRight, .topLeft]
            topLine.isHidden = true
        }
        if index == 2 {
            corners = [.bottomLeft, .bottomRight]
            bottomLine.isHidden = true
        }
        insideBGView.roundCorners(corners: corners, radius: 12)
    }
    
    private func loadFromNib() {
        
        Bundle.main.loadNibNamed("TaskBlockView", owner: self, options: nil)
        
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.backgroundColor = .clear
        addSubview(contentView)
    }
}
