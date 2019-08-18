//
//  CompletionView.swift
//  FocusOn
//
//  Created by Rafal Padberg on 20.05.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import UIKit

class CompletionView: UIView {
    
    enum CompletionSign {
        
        case none
        case success
        case fail
    }
    
    // MARK:- Outlets
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var insideView: UIView!
    @IBOutlet weak var oneThirdCover: UIView!
    @IBOutlet weak var pathLayer: UIView!
    
    // MARK:- Private Properties
    
    private var oneThirds: [UIView] = []
    
    private var animationDuration: Double = 0.4
    private var currentRotation: CGFloat = 0
    private var lastRotation: CGFloat = 0
    private var completionSign: CompletionSign = .none
    private var lastCompletionSign: CompletionSign = .none
    
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
    
    // MARK:- Public Methods
    
    func changeTo(progress: Goal.CompletionProgress) {
        
        lastRotation = currentRotation
        completionSign = .none
        
        switch progress {
        case .notCompleted:
            currentRotation = 0
        case .oneThird:
            currentRotation = 120
        case .twoThirds:
            currentRotation = 240
        case .completed:
            currentRotation = 360
            completionSign = .success
        case .notYetAchieved:
            currentRotation = 360
            completionSign = .fail
        }
        animateSwitchChange()
    }
    
    func toggleNotYetAchieved() {
        
        animateRemovingPath()
        
        delayContinuation(by: animationDuration * 1.1) {
            
            if self.lastCompletionSign == .fail {
                
                self.completionSign = .success
            } else {
                
                self.completionSign = .fail
            }
            self.addCompletionSign()
        }
    }
    
    // MARK:- PRIVATE:
    // MARK:- Animation Methods
    
    private func animateSwitchChange() {
        
        let halfRotation = (currentRotation + lastRotation) / 2
        
        if halfRotation == 0 { return }
        
        let dRotation = abs(currentRotation - lastRotation)
        
        var time: Double = 0
        if lastRotation == 360 {
            
            time = animationDuration * 1.1
            if currentRotation == 360 {
                
                if completionSign == lastCompletionSign { return }
                
                animateRemovingPath()
            } else {
                
                addCompletionSign()
            }
        }
        delayContinuation(by: time) {
            
            if dRotation < 180 {
                
                self.animateChangeInOneStep()
            } else {
                
                if dRotation == 360 {
                    
                    self.animateChangeForFullRotation()
                } else {
                    
                    self.animateChangeInTwoSteps(halfRotation: halfRotation)
                }
            }
        }
    }
    
    private func animateDrawingPath() {
        
        let animation = CABasicAnimation.basicWith(keyPath: "strokeEnd", duration: animationDuration)
        pathLayer.layer.sublayers?.forEach { $0.add(animation, forKey: nil) }
    }
    
    private func animateRemovingPath() {
        
        let animation = CABasicAnimation.basicWith(keyPath: "strokeStart", fromValue: 0, toValue: 1, duration: animationDuration)
        animation.delegate = self
        
        pathLayer.layer.sublayers?.forEach { $0.add(animation, forKey: nil) }
    }
    
    private func animateChangeInOneStep() {
        
        UIView.animate(withDuration: animationDuration, animations: {
            
            self.transformAllThirdsView()
        }) { [weak self] _ in
            
            self?.oneThirdCover.alpha = self!.currentRotation >= 240 ? 0 : 1
            self?.addCompletionSign()
        }
    }
    
    private func animateChangeInTwoSteps(halfRotation: CGFloat) {
        
        let duration = animationDuration / 2
        let isFullRotation = currentRotation >= 240
        
        UIView.animate(withDuration: duration, animations: {
            
            self.transformAllThirdsView(toResembleRotationOf: halfRotation)
        }) { [weak self] _ in
            
            self?.oneThirdCover.alpha = isFullRotation ? 0 : 1
            
            UIView.animate(withDuration: duration, animations: {
                
                self?.transformAllThirdsView()
            }, completion: { _ in

                self?.animateChangeInOneStep()
            })
        }
    }
    
    private func animateChangeForFullRotation() {
        
        let isAnimatingBack = currentRotation == 0
        let duration = 3 * animationDuration / 6
        let isFullRotation = currentRotation >= 240
        
        UIView.animate(withDuration: duration, animations: {
            
            self.transformAllThirdsView(toResembleRotationOf: isAnimatingBack ? 240 : 120)
        }) { [weak self] _ in
            
            self?.oneThirdCover.alpha = isFullRotation ? 0 : 1
            
            UIView.animate(withDuration: duration, delay: 0.1, animations: {
                
                self?.transformAllThirdsView(toResembleRotationOf: isAnimatingBack ? 120 : 240)
            }, completion: { _ in
                
                self?.oneThirdCover.alpha = isFullRotation ? 0 : 1
                self?.animateChangeInOneStep()
            })
        }
    }
    
    // MARK:- Path & Layer Drawing Methods
    
    private func maskToOneThirdFraction(_ view: UIView, isInitialThird: Bool = false) {
        
        let halfWidth = view.bounds.width / 2
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: halfWidth, y: 0))
        path.addLine(to: CGPoint(x: halfWidth, y: halfWidth))
        
        var y: CGFloat!
        
        if isInitialThird {
            // (tan(30 degree) + 1) * halfWidth == halfWidth * ((3 + sqrt(3.0)) / 3)
            y = (tan(CGFloat.pi / 6) + 1) * halfWidth
        } else {
            
            y = halfWidth
        }
        
        path.addLine(to: CGPoint(x: 0, y: y))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.move(to: CGPoint(x: halfWidth, y: 0))
        path.close()
        
        let pathLayer = CAShapeLayer()
        pathLayer.path = path.cgPath
        
        view.layer.mask = pathLayer
    }
    
    private func addCompletionSign() {
        
        switch completionSign {
        case .success:
            
            drawSuccessPath()
        case .fail:
            
            drawFailPath()
        default:
            
            animateRemovingPath()
        }
        lastCompletionSign = completionSign
    }
    
    private func drawSuccessPath() {
        
        let width = insideView.bounds.width
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0.25 * width, y: 0.5 * width))
        path.addLine(to: CGPoint(x: 0.46 * width, y: 0.69 * width))
        path.addLine(to: CGPoint(x: 0.77 * width, y: 0.32 * width))
        
        pathLayer.layer.addSublayer(CAShapeLayer.basicWith(path: path.cgPath))
        
        animateDrawingPath()
    }
    
    private func drawFailPath() {
        
        let width = insideView.bounds.width
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0.3 * width, y: 0.3 * width))
        path.addLine(to: CGPoint(x: 0.7 * width, y: 0.7 * width))
        
        let path2 = UIBezierPath()
        path2.move(to: CGPoint(x: 0.3 * width, y: 0.3 * width))
        path2.addLine(to: CGPoint(x: 0.5 * width, y: 0.5 * width))
        path2.addLine(to: CGPoint(x: 0.7 * width, y: 0.3 * width))
        
        let path3 = UIBezierPath()
        path3.move(to: CGPoint(x: 0.3 * width, y: 0.3 * width))
        path3.addLine(to: CGPoint(x: 0.5 * width, y: 0.5 * width))
        path3.addLine(to: CGPoint(x: 0.3 * width, y: 0.7 * width))
        
        let pathArray = [path, path2, path3]
        
        for i in 0 ..< 3 {
            
            pathLayer.layer.addSublayer(CAShapeLayer.basicWith(path: pathArray[i].cgPath))
        }
        animateDrawingPath()
    }
    
    // MARK:- Custom Methods
    
    private func delayContinuation(by time: Double, completion: @escaping (() -> Void)) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            
            completion()
        }
    }
    
    private func transformAllThirdsView(toResembleRotationOf rotation: CGFloat? = nil) {
        
        for i in 0 ..< 5 {
            
            oneThirds[i].transform = CGAffineTransform(rotationAngle: getRotationOfView(positionsBefore: CGFloat(i), with: rotation ?? currentRotation) * CGFloat.pi / 180)
        }
    }
    
    private func getRotationOfView(positionsBefore: CGFloat, with rotation: CGFloat) -> CGFloat {
        
        if positionsBefore == 4 {
            return rotation.returnInRange(minValue: 0, maxValue: 90)
        }
        return rotation.returnInRange(minValue: 0, maxValue: 360 - positionsBefore * 60)
    }
    
    private func setupUI() {
        
        oneThirdCover.backgroundColor = UIColor.Main.berkshireLace
        insideView.backgroundColor = UIColor.Main.berkshireLace
        topView.backgroundColor = UIColor.Main.atlanticDeep
        
        insideView.layer.cornerRadius = insideView.bounds.height / 2
        topView.layer.cornerRadius = topView.bounds.height / 2
        
        
//        let colors: [UIColor] = [.red, .green, .blue, .yellow, .magenta]
        for _ in 0 ..< 5 {
            
            let view = UIView(frame: insideView.bounds)
//            view.backgroundColor = colors[i]
            view.backgroundColor = UIColor.Main.atlanticDeep
            
            insideView.insertSubview(view, at: 0)
            maskToOneThirdFraction(view)
            oneThirds.append(view)
        }
        maskToOneThirdFraction(oneThirdCover, isInitialThird: true)
    }
    
    private func loadFromNib() {
        
        Bundle.main.loadNibNamed("CompletionView", owner: self, options: nil)
        
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundColor = .clear
        addSubview(contentView)
    }
}

// MARK:- CAAnimationDelegate Methods

extension CompletionView: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        pathLayer.layer.sublayers?.last?.removeFromSuperlayer()
    }
}
