//
//  AnimatedMaskView.swift
//  FocusOn
//
//  Created by Rafal Padberg on 21.07.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import UIKit

class AnimatedMaskView: UIView, CAAnimationDelegate {
    
    enum MessageType {
        
        case notAllTasksDefined
        case formNotComplete
        case goalIsEmpty
    }
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var insideView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    private var maskLayer: CAShapeLayer!
    
    private var randomMaskLayer: CAShapeLayer!
    private var fullMaskLayer: CAShapeLayer!
    
    private let animationDuration: Double = 0.4
    private var fontAttributes: [NSAttributedString.Key : NSObject]!
    private var isDuringAnimation: Bool = false
    
    // MARK:- Initializers Methods
    
    override func awakeFromNib() {
        
        loadFromNib()
        initialSetup()
    }
    
    // MARK:- Public Methods
    
    func show(with messageType: MessageType) {
        if isDuringAnimation { return }
        
        isDuringAnimation = true
        
        var text: String!
        switch messageType {
        case .formNotComplete:
            text = "You have to fill out everything first!"
        case .notAllTasksDefined:
            text = "Define all tasks first!"
        case .goalIsEmpty:
            text = "Goal cannot be empty!"
        }
        messageLabel.attributedText = NSAttributedString(string: text, attributes: fontAttributes)
        animateStart()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.animateEnd()
        }
    }
    
    // MARK:- PRIVATE
    // MARK:- Custom Methods
    
    private func initialSetup() {
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = CGPath(rect: bounds.extendBy(xFactor: 1.1, yFactor: 1.1), transform: nil)
        fullMaskLayer = maskLayer
        
        randomMaskLayer = randomizeMask()
        layer.mask = randomMaskLayer
        
        insideView.layer.cornerRadius = 6
        insideView.backgroundColor = UIColor.Main.studio
        insideView.addSimpleShadow(color: UIColor.Main.treetop, radius: 2, opacity: 0.6, offset: .zero)
        
        let font = UIFont(name: "Avenir-Regular", size: 13) ?? UIFont.systemFont(ofSize: 13, weight: .regular)
        fontAttributes = [NSAttributedString.Key.foregroundColor: UIColor.Main.berkshireLace, NSAttributedString.Key.font : font]
    }
    
    private func randomizeMask() -> CAShapeLayer {
        
        let maskLayer = CAShapeLayer()
        let random = Int.random(in: 0 ..< 4)
        let x: CGFloat = random == 0 ? 1 : random == 2 ? -1 : 0
        let y: CGFloat = random == 1 ? 1 : random == 3 ? -1 : 0
        
        let rect = CGRect(origin: .zero, size: bounds.size).extendBy(xFactor: 1.1, yFactor: 1.1).moveBy(width: x, height: y)
        print(rect)
        maskLayer.path = CGPath(rect: rect, transform: nil)
        return maskLayer
    }
    
    private func loadFromNib() {
        
        Bundle.main.loadNibNamed("AnimatedMaskView", owner: self, options: nil)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundColor = .clear
        addSubview(contentView)
    }
    
    // MARK:- Animation Methods
    
    private func animateStart() {
        
        randomMaskLayer = randomizeMask()
        layer.mask = randomMaskLayer
        
        let anim = CABasicAnimation(keyPath: "path")
        anim.delegate = self
        anim.fromValue = randomMaskLayer.path
        anim.toValue = fullMaskLayer.path
        anim.isRemovedOnCompletion = true
        anim.duration = animationDuration
        anim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        randomMaskLayer.add(anim, forKey: nil)
    }
    
    private func animateEnd() {
        
        randomMaskLayer = randomizeMask()
        
        let anim = CABasicAnimation(keyPath: "path")
        anim.delegate = self
        anim.fromValue = fullMaskLayer.path
        anim.toValue = randomMaskLayer.path
        anim.isRemovedOnCompletion = true
        anim.duration = animationDuration
        anim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        fullMaskLayer.add(anim, forKey: nil)
    }
    
    // MARK:- CAAnimationDelegate Methods
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        if self.layer.mask == fullMaskLayer {
            
            self.layer.mask = randomMaskLayer
            isDuringAnimation = false
        } else {
            self.layer.mask = fullMaskLayer
        }
        
    }
}
