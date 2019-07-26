//
//  TaskBlockView.swift
//  FocusOn
//
//  Created by Rafal Padberg on 20.06.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import UIKit

class TaskBlockView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var insideView: UIView!
    @IBOutlet weak var insideBGView: UIView!
    @IBOutlet weak var numberImageView: UIImageView!
    @IBOutlet weak var checkBox: TaskCheckButtonView!
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var taskLabel: UILabel!
    
    @IBOutlet weak var topLine: UIView!
    @IBOutlet weak var bottomLine: UIView!
    
    var parentConnection: TodayViewController!
    
    private var animationDuration: Double = 0.4
    
    // MARK:- Initializers
    
    override func awakeFromNib() {
        
        loadFromNib()
    }
    
    // MARK:- View Life Cycle Methods
    
    override func layoutSubviews() {
        
        setupUI()
    }
    
    // MARK:- Public Methods
    
    func turn() {
        let transform3 = transformForFraction(2, ofWidth: 30)
        
        self.insideView.subviews.forEach { $0.alpha = 0 }
        self.insideView.layer.cornerRadius = 12
        self.insideView.layer.borderColor = UIColor.Main.rosin.cgColor
        self.insideView.layer.borderWidth = 1.0
        self.insideView.layer.transform = transform3
    }
    
    func turnBack(delayBy: Int) {
        let transform = transformForFraction(1, ofWidth: 30)
        let transform2 = transformForFraction(0, ofWidth: 30)
        
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
        if parent != nil {
            parentConnection = parent
            taskTextField.delegate = parent
            checkBox.parentConnection = self
            alpha = 0
        }
        
        var index = self.tag
        
        taskTextField.tag = index
        taskTextField.isHidden = parent == nil
        taskLabel.isHidden = parent != nil
        checkBox.checkButton.tag = index
        
        topLine.backgroundColor = UIColor.Main.rosin
        bottomLine.backgroundColor = UIColor.Main.rosin
        
        insideView.addSimpleShadow(color: UIColor.Main.atlanticDeep, radius: 8.0, opacity: parent == nil ? 0.1 :0.4, offset: CGSize(width: 0, height: -2))
        insideBGView.backgroundColor = UIColor.Main.berkshireLace.withAlphaComponent(parent == nil ? 0.9 : 0.5)
        numberImageView.image = UIImage(named: "\(index + 1)")
        
        index += index == 0 && parent == nil ? 1 : 0
        
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
        print(taskTextField.text)
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
    
    private func transformForFraction(_ fraction: CGFloat, ofWidth width: CGFloat)
        -> CATransform3D {
            //1
            var identity = CATransform3DIdentity
            identity.m34 = -1.0 / 1000.0
            
            //2
            let angle = -fraction * .pi/2.0
            
            //3
            let rotateTransform = CATransform3DRotate(identity, angle, 1.0, 0.0, 0.0)
            return rotateTransform
    }
    
    private func setupUI() {
        
        self.backgroundColor = .clear
    }
    
    private func loadFromNib() {
        
        Bundle.main.loadNibNamed("TaskBlockView", owner: self, options: nil)
        
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
    }
}
