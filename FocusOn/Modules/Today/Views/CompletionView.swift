//
//  CompletionView.swift
//  FocusOn
//
//  Created by Rafal Padberg on 20.05.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import UIKit

class CompletionView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var insideView: UIView!
    @IBOutlet weak var oneThirdCover: UIView!
    @IBOutlet weak var pathLayer: UIView!
    
    var animationDuration: Double = 0.4
    
    private var oneThirds: [UIView] = []
    private var lastRotation: CGFloat = 0
    private var currentRotation: CGFloat = 0
    
    private var sign: Int = 0
    
    // MARK:- Initializers
    
    override func awakeFromNib() {
        
        loadFromNib()
    }
    
    // MARK:- View Life Cycle Methods
    
    override func layoutSubviews() {
        
        contentView.layoutSubviews()
        topView.layoutSubviews()
        insideView.layoutSubviews()
        
        setupUI()
    }
    
    // MARK:- Private Methods
    
    func changeTo(progress: Goal.CompletionProgress) {
        lastRotation = currentRotation
        sign = 0
        switch progress {
        case .notCompleted:
            currentRotation = 0
        case .oneThird:
            currentRotation = 120
        case .twoThirds:
            currentRotation = 240
        case .completed:
            currentRotation = 360
            sign = 1
        case .notYetAchieved:
            sign = 2
            break
        }
        animateSwitchChange()
    }
    
    // MARK:- PRIVATE:
    // MARK:- Animation Methods
    
    private func animateSwitchChange() {
        let halfRotation = (currentRotation + lastRotation) / 2
        let dRotation = abs(currentRotation - lastRotation)
        if halfRotation == 0 { return }
        if dRotation < 180 {
            animateCompletionChange()
            return
        }
        
        UIView.animate(withDuration: 2 * animationDuration / 3, animations: {
            self.changeRotations(to: halfRotation)
        }) { [weak self] _ in
            self?.oneThirdCover.alpha = self!.currentRotation >= 240 ? 0 : 1
            UIView.animate(withDuration: 2 * self!.animationDuration / 3, animations: {
                self?.changeRotations(to: self!.currentRotation)
            }, completion: { _ in
                self?.oneThirdCover.alpha = self!.currentRotation >= 240 ? 0 : 1
                self?.addSign()
            })
        }
    }
    
    var lastFail: Bool = false
    
    func addSign() {
        print("SIGN")
        pathLayer.layer.sublayers?.last?.removeFromSuperlayer()
        if lastFail {
            pathLayer.layer.sublayers?.last?.removeFromSuperlayer()
            pathLayer.layer.sublayers?.last?.removeFromSuperlayer()
            lastFail = false
        }
        if sign == 1 {
            print("DRAW CHECK")
            drawCheckPath()
        }
        if sign == 2 {
            print("DRAW FAIL")
            drawFailPath()
            lastFail = true
        }
    }
    
    private func animateCompletionChange() {
        let dRotation = abs(currentRotation - lastRotation)
        
        UIView.animate(withDuration: animationDuration, animations: {
            self.changeRotations(to: self.currentRotation)
        }) { [weak self] _ in
            self?.oneThirdCover.alpha = self!.currentRotation >= 240 ? 0 : 1
            self?.addSign()
        }
    }
    
    // MARK:- Custom Methods
    
    private func getRotationOfView(positionsBefore: CGFloat, with rotation: CGFloat) -> CGFloat {
        return rotation.returnInRange(minValue: 0, maxValue: 360 - positionsBefore * 120)
    }
    
    private func changeRotations(to rotation: CGFloat) {
        for i in 0 ..< 3 {
            oneThirds[i].transform = CGAffineTransform(rotationAngle: getRotationOfView(positionsBefore: CGFloat(i), with: rotation) * CGFloat.pi / 180)
        }
    }
    
    private func maskToOneThirdFraction(_ view: UIView, isInitialThird: Bool = false) {
        
        view.layer.cornerRadius = view.bounds.height / 2
        
        let pathLayer = CAShapeLayer()
        let path = UIBezierPath()
        
        let halfWidth = view.bounds.width / 2
        
        path.move(to: CGPoint(x: halfWidth, y: 0))
        path.addLine(to: CGPoint(x: halfWidth, y: halfWidth))
        
        // (tan(30 degree) + 1) * halfWidth == halfWidth * ((3 + sqrt(3.0)) / 3)
        let y = (tan(CGFloat.pi / 6) + (isInitialThird ? 1.05 : 1.0)) * halfWidth
        
        path.addLine(to: CGPoint(x: 0, y: y))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.move(to: CGPoint(x: halfWidth, y: 0))
        path.close()
        
        pathLayer.path = path.cgPath
        view.layer.mask = pathLayer
    }
    
    private func drawCheckPath() {
        
        let width = insideView.bounds.width
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0.25 * width, y: 0.5 * width))
        path.addLine(to: CGPoint(x: 0.46 * width, y: 0.69 * width))
        path.addLine(to: CGPoint(x: 0.77 * width, y: 0.32 * width))
        
        let checkLayer = CAShapeLayer()
        checkLayer.path = path.cgPath
        checkLayer.strokeColor = UIColor.black.cgColor
        checkLayer.fillColor = nil
        checkLayer.lineWidth = 4.0
        checkLayer.strokeEnd = 1
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = animationDuration
        animation.autoreverses = false
        animation.repeatCount = 1
        checkLayer.add(animation, forKey: "line2")
        
        pathLayer.layer.addSublayer(checkLayer)
    }
    
    private func drawFailPath() {
        let width = insideView.bounds.width
        
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
        var failLayers: [CAShapeLayer] = []
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = animationDuration
        animation.autoreverses = false
        animation.repeatCount = 1
        
        for i in 0 ..< 3 {
            let layer = CAShapeLayer()
            layer.path = pathArray[i].cgPath
            layer.strokeColor = UIColor.black.cgColor
            layer.fillColor = nil
            layer.lineWidth = 4.0
            failLayers.append(layer)
            layer.add(animation, forKey: "failAnimation")
            pathLayer.layer.addSublayer(layer)
        }
    }
    
    private func animateCheck(isSelected: Bool) {
        
    }
    
    private func animateFail() {
        
    }
    
    private func setupUI() {
        
        backgroundColor = .clear
        oneThirdCover.backgroundColor = UIColor.Main.berkshireLace
        insideView.backgroundColor = UIColor.Main.berkshireLace
        topView.backgroundColor = UIColor.Main.atlanticDeep
        
        insideView.layer.cornerRadius = insideView.bounds.height / 2
        topView.layer.cornerRadius = topView.bounds.height / 2
        
        for _ in 0 ..< 3 {
            let view = UIView(frame: insideView.bounds)
            view.backgroundColor = UIColor.Main.atlanticDeep
            insideView.insertSubview(view, at: 0)
            maskToOneThirdFraction(view)
            oneThirds.append(view)
            print("ADD oneTHird")
        }
        maskToOneThirdFraction(oneThirdCover, isInitialThird: true)
    }
    
    private func loadFromNib() {
        
        Bundle.main.loadNibNamed("CompletionView", owner: self, options: nil)
        
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
    }
}
