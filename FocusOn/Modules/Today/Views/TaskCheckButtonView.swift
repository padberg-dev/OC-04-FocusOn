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
    
    var parentConnection: TaskBlockView!
    
    private var distanceFromEdge: CGFloat = 2.0
    private var pathRadius: CGFloat = 8.0
    private var lineWidth: CGFloat = 1.0
    private var animationDuration: Double = 0.4
    
    private var borderLayer: CAShapeLayer = CAShapeLayer()
    private var checkLayer: CAShapeLayer = CAShapeLayer()
    private var failLayers: [CAShapeLayer] = []
    
    var isSelected: Bool = false
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
    
    func set(selected: Bool, immediately: Bool = false) {
        if !immediately && isSelected == selected { return }
        isSelected = selected
        if immediately {
            checkLayer.strokeEnd = isSelected ? 1 : 0
            parentConnection.activateTextField(isSelected: isSelected, immediately: immediately)
            if isSelected || parentConnection.taskTextField.text != "" {
                pathView.layer.addSublayer(borderLayer)
                isBorderOn = true
            }
        } else {
            animateCheck(isSelected: selected)
            parentConnection.activateTextField(isSelected: isSelected)
        }
        parentConnection.changeImage(toFilled: isSelected, immediate: immediately)
    }
    
    func hide() {
        
        let view = UIView(frame: CGRect(x: distanceFromEdge - lineWidth / 2, y: distanceFromEdge - lineWidth / 2, width: width - 2 * distanceFromEdge + lineWidth, height: width - 2 * distanceFromEdge + lineWidth))
        view.alpha = 1
        view.backgroundColor = .clear
        view.layer.cornerRadius = pathRadius
        insideView.insertSubview(view, at: 0)
        
        let newWidth = view.bounds.width
        
        let view2 = UIView(frame: CGRect(x: lineWidth, y: lineWidth, width: newWidth - 2 * lineWidth, height: newWidth - 2 * lineWidth))
        view2.alpha = 1
        view2.backgroundColor = UIColor.Main.berkshireLace//UIColor.Main.lagoon
        view2.layer.cornerRadius = 0
        view2.transform = CGAffineTransform(scaleX: 0, y: 0)
        view.addSubview(view2)
        
            
        UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut, animations: {

            view2.layer.cornerRadius = self.pathRadius * 0.8
            view2.transform = .identity
            if !self.isSelected { self.animateFail() }
            if self.isSelected { self.animateCheck(isSelected: true) }
        }) { [weak self] _ in
            view.backgroundColor = .white
            self?.pathView.alpha = 0
            UIView.animate(withDuration: self!.animationDuration) {
                view.layer.cornerRadius = view.bounds.width / 2
                view2.layer.cornerRadius = view2.bounds.width / 2
            }
        }
    }
    
    func unHide() {
        self.pathView.alpha = 1
        insideView.subviews.last?.removeFromSuperview()
    }
    
    // MARK:- PRIVATE
    // MARK:- Custom Methods
    
    private func setupUI() {
        
        self.backgroundColor = .clear
        
        width = bounds.width
        
        drawBorderPath()
        drawCheckPath()
        drawFailPath()
    }
    
    private func loadFromNib() {
        
        Bundle.main.loadNibNamed("TaskCheckButtonView", owner: self, options: nil)
        
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
    }
    
    // MARK:- Animation Methods
    
    private func animateBorder() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = animationDuration
        animation.autoreverses = false
        animation.repeatCount = 1
        
        borderLayer.add(animation, forKey: "line")
        pathView.layer.addSublayer(borderLayer)
    }
    
    private func animateCheck(isSelected: Bool) {
        checkLayer.strokeEnd = isSelected ? 1 : 0
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = isSelected ? 0 : 1
        animation.toValue = isSelected ? 1 : 0
        animation.duration = animationDuration
        animation.autoreverses = false
        animation.repeatCount = 1
        checkLayer.add(animation, forKey: "line2")
    }
    
    private func animateFail() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = animationDuration
        animation.autoreverses = false
        animation.repeatCount = 1
        
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
        
        borderLayer.path = path.cgPath
        borderLayer.strokeColor = UIColor.white.cgColor
        borderLayer.fillColor = nil
        borderLayer.lineWidth = lineWidth
    }
    
    private func drawCheckPath() {
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0.25 * width, y: 0.5 * width))
        path.addLine(to: CGPoint(x: 0.46 * width, y: 0.69 * width))
        path.addLine(to: CGPoint(x: 0.77 * width, y: 0.32 * width))
        
        checkLayer.path = path.cgPath
        checkLayer.strokeColor = UIColor.white.cgColor
        checkLayer.fillColor = nil
        checkLayer.lineWidth = lineWidth
        checkLayer.strokeEnd = 0
        
        insideView.layer.addSublayer(checkLayer)
    }
    
    private func drawFailPath() {
        
        let path = UIBezierPath()
        let path2 = UIBezierPath()
        let path3 = UIBezierPath()
        path.move(to: CGPoint(x: 0.35 * width, y: 0.35 * width))
        path.addLine(to: CGPoint(x: 0.65 * width, y: 0.65 * width))
        path2.move(to: CGPoint(x: 0.35 * width, y: 0.35 * width))
        path2.addLine(to: CGPoint(x: 0.5 * width, y: 0.5 * width))
        path2.addLine(to: CGPoint(x: 0.65 * width, y: 0.35 * width))
        path3.move(to: CGPoint(x: 0.35 * width, y: 0.35 * width))
        path3.addLine(to: CGPoint(x: 0.5 * width, y: 0.5 * width))
        path3.addLine(to: CGPoint(x: 0.35 * width, y: 0.65 * width))
        
        let pathArray = [path, path2, path3]
        
        for i in 0 ..< 3 {
            let layer = CAShapeLayer()
            layer.path = pathArray[i].cgPath
            layer.strokeColor = UIColor.white.cgColor
            layer.fillColor = nil
            layer.lineWidth = lineWidth
            failLayers.append(layer)
        }
    }
    
    // MARK:- Action Methods

    @IBAction func buttonTapped(_ sender: UIButton) {
        print("Tapped \(isSelected)")
        if parentConnection.validateTask() {
            set(selected: !isSelected)
            parentConnection.parentConnection.taskButtonTapped(buttonTag: parentConnection.tag)
        } else {
            print("No text in the Task-TextField BUTTON")
        }
    }
}
