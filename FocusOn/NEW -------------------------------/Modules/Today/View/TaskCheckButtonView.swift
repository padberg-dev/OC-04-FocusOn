//
//  TaskCheckButtonView.swift
//  FocusOn
//
//  Created by Rafal Padberg on 20.06.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import UIKit

class TaskCheckButtonView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet var insideView: UIView!
    @IBOutlet var pathView: UIView!
    @IBOutlet var checkButton: UIButton!
    
    var parentConnection: TaskBlockView?
    
    private var distanceFromEdge: CGFloat = 2.0
    private var pathRadius: CGFloat = 8.0
    private var lineWidth: CGFloat = 1.0
    private var animationDuration: Double = 0.4
    private var strokeColor: UIColor = UIColor.white
    
    private var borderLayer: CAShapeLayer = CAShapeLayer()
    private var checkLayer: CAShapeLayer = CAShapeLayer()
    private var failLayers: [CAShapeLayer] = []
    
    private var isSelected: Bool = false
    private var isBorderOn: Bool = false
    
    private var width: CGFloat!
    
    // MARK:- Initializers
    
    override func awakeFromNib() {
        
        loadFromNib()
    }
    
    // MARK:- View Life Cycle Methods
    
    override func layoutSubviews() {
        
        setupUI()
    }
    
    // MARK:- Public Methods
    
    func show() {
        
        if !isBorderOn {
            
            animateBorder()
            isBorderOn = true
        }
    }
    
    func setAlternative(selected: Bool) {
        
        insideView.layer.sublayers?.last?.removeFromSuperlayer()
        strokeColor = UIColor.Main.atlanticDeep
        lineWidth = 2
        
        if selected {
            drawCheckPath()
        } else {
            drawFailPath()
        }
        checkLayer.strokeEnd = 1
    }
    
    func set(selected: Bool, immediately: Bool = false) {
        
        if !immediately && isSelected == selected { return }
        isSelected = selected
        
        if immediately {
            checkLayer.strokeEnd = isSelected ? 1 : 0
            parentConnection?.activateTextField(isSelected: isSelected, immediately: immediately)
            
            if isSelected || parentConnection?.taskTextField.text != "" {
                pathView.layer.addSublayer(borderLayer)
                isBorderOn = true
            }
        } else {
            animateCheck(isSelected: selected)
            parentConnection?.activateTextField(isSelected: isSelected)
        }
        parentConnection?.changeImage(toFilled: isSelected, immediate: immediately)
    }
    
    // MARK:- PRIVATE
    // MARK:- Custom Methods
    
    private func setupUI() {
        
        width = bounds.width
        
        drawBorderPath()
        drawCheckPath()
    }
    
    private func loadFromNib() {
        
        Bundle.main.loadNibNamed("TaskCheckButtonView", owner: self, options: nil)
        
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.backgroundColor = .clear
        addSubview(contentView)
    }
    
    // MARK:- Animation Methods
    
    private func animateBorder() {
        
        let animation = CABasicAnimation.basicWith(keyPath: "strokeEnd", duration: animationDuration)
        
        borderLayer.add(animation, forKey: "line")
        pathView.layer.addSublayer(borderLayer)
    }
    
    private func animateCheck(isSelected: Bool) {
        
        checkLayer.strokeEnd = isSelected ? 1 : 0
        
        let animation = CABasicAnimation.basicWith(
            keyPath: "strokeEnd",
            fromValue: isSelected ? 0 : 1,
            toValue: isSelected ? 1 : 0,
            duration: animationDuration)
        
        checkLayer.add(animation, forKey: "line2")
    }
    
    private func animateFail() {
        
        let animation = CABasicAnimation.basicWith(keyPath: "strokeEnd", duration: animationDuration)
        
        failLayers.forEach { failLayer in
            
            failLayer.add(animation, forKey: "failAnimation")
            self.insideView.layer.addSublayer(failLayer)
        }
    }
    
    // MARK:- Layer and Path Methods
    
    private func drawBorderPath() {
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: width / 2, y: distanceFromEdge))
        path.addLine(to: CGPoint(x: distanceFromEdge + pathRadius, y: distanceFromEdge))
        path.addQuadCurve(to: CGPoint(x: distanceFromEdge, y: distanceFromEdge + pathRadius), controlPoint: CGPoint(x: distanceFromEdge, y: distanceFromEdge))
        path.addLine(to: CGPoint(x: distanceFromEdge, y: width - (distanceFromEdge + pathRadius)))
        path.addQuadCurve(to: CGPoint(x: distanceFromEdge + pathRadius, y: width - distanceFromEdge), controlPoint: CGPoint(x: distanceFromEdge, y: width - distanceFromEdge))
        path.addLine(to: CGPoint(x: width - (distanceFromEdge + pathRadius), y: width - distanceFromEdge))
        path.addQuadCurve(to: CGPoint(x: width - distanceFromEdge, y: width - (distanceFromEdge + pathRadius)), controlPoint: CGPoint(x: width - distanceFromEdge, y: width - distanceFromEdge))
        path.addLine(to: CGPoint(x: width - distanceFromEdge, y: distanceFromEdge + pathRadius))
        path.addQuadCurve(to: CGPoint(x: width - (distanceFromEdge + pathRadius), y: distanceFromEdge), controlPoint: CGPoint(x: width - distanceFromEdge, y: distanceFromEdge))
        path.close()
        
        borderLayer = CAShapeLayer.basicWith(path: path.cgPath, strokeColor: UIColor.white.cgColor, lineWidth: lineWidth)
    }
    
    private func drawCheckPath() {
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0.25 * width, y: 0.5 * width))
        path.addLine(to: CGPoint(x: 0.46 * width, y: 0.69 * width))
        path.addLine(to: CGPoint(x: 0.77 * width, y: 0.32 * width))
        
        checkLayer = CAShapeLayer.basicWith(path: path.cgPath, strokeColor: strokeColor.cgColor, lineWidth: lineWidth)
        checkLayer.strokeEnd = 0
        
        insideView.layer.addSublayer(checkLayer)
    }
    
    private func drawFailPath() {
        
        let path = UIBezierPath()
        let path2 = UIBezierPath()
        path.move(to: CGPoint(x: 0.3 * width, y: 0.3 * width))
        path.addLine(to: CGPoint(x: 0.7 * width, y: 0.7 * width))
        path2.move(to: CGPoint(x: 0.3 * width, y: 0.7 * width))
        path2.addLine(to: CGPoint(x: 0.7 * width, y: 0.3 * width))
        
        let pathArray = [path, path2]
        
        for i in 0 ..< 2 {
            
            failLayers.append(CAShapeLayer.basicWith(path: pathArray[i].cgPath, strokeColor: strokeColor.cgColor, lineWidth: lineWidth))
            insideView.layer.addSublayer(failLayers[i])
        }
    }
    
    // MARK:- Action Methods

    @IBAction func checkBoxTapped(_ sender: UIButton) {
        
        if parentConnection?.validateTask() ?? false {
            
            set(selected: !isSelected)
            parentConnection?.parentConnection?.taskButtonTapped(buttonTag: checkButton.tag)
        }
    }
}
