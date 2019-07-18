//
//  CompletionBlockView.swift
//  FocusOn
//
//  Created by Rafal Padberg on 21.06.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import UIKit

class CompletionBlockView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet var completionView: CompletionView!
    @IBOutlet var pathView: UIView!
    
    private var initialLayerLeft: CAShapeLayer = CAShapeLayer()
    private var initialLayerRight: CAShapeLayer = CAShapeLayer()

    private var distanceFromEdge: CGFloat = 2.0
    private var pathRadius: CGFloat = 8.0
    private var lineWidth: CGFloat = 2.0
    private var animationDuration: Double = 0.4
    
    // MARK:- Initializers
    
    override func awakeFromNib() {
        
        loadFromNib()
    }
    
    // MARK:- View Life Cycle Methods
    
    override func layoutSubviews() {
        
        setupUI()
    }
    
    // MARK:- PRIVATE
    // MARK:- Animation Methods
    
    private func animateStart() {
        
    }
    
    // MARK:- Layer and Path Methods
    
    private func drawInitialPath() {
        let width = self.bounds.width
        let height = self.bounds.height
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: height / 2))
        path.addLine(to: CGPoint(x: (width / 2) + 1 - (completionView.bounds.width / 2), y: height / 2))
        path.addArc(withCenter: CGPoint(x: width / 2, y: height / 2), radius: completionView.bounds.height / 2 - 1, startAngle: CGFloat.pi, endAngle: CGFloat.pi - 0.01, clockwise: true)
        
        initialLayerLeft.path = path.cgPath
        initialLayerLeft.strokeColor = UIColor.Main.atlanticDeep.cgColor
        initialLayerLeft.fillColor = nil
        initialLayerLeft.lineWidth = lineWidth
        
        let path2 = UIBezierPath()
        path2.move(to: CGPoint(x: width, y: height / 2))
        path2.addLine(to: CGPoint(x: (width / 2) - 1 + (completionView.bounds.width / 2), y: height / 2))
        path2.addArc(withCenter: CGPoint(x: width / 2, y: height / 2), radius: completionView.bounds.height / 2 - 1, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        initialLayerRight.path = path2.cgPath
        initialLayerRight.strokeColor = UIColor.Main.atlanticDeep.cgColor
        initialLayerRight.fillColor = nil
        initialLayerRight.lineWidth = lineWidth
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 2.0
        animation.autoreverses = false
        animation.repeatCount = 1
        
        let animation2 = CABasicAnimation(keyPath: "strokeStart")
        animation2.fromValue = 0
        animation2.toValue = 0.5
        animation2.duration = 0.8
        animation2.autoreverses = false
        animation2.repeatCount = 1
        
        initialLayerLeft.add(animation, forKey: nil)
        initialLayerRight.add(animation, forKey: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.initialLayerLeft.strokeStart = 0.5
            self.initialLayerRight.strokeStart = 0.5
            self.initialLayerLeft.add(animation2, forKey: nil)
            self.initialLayerRight.add(animation2, forKey: nil)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            UIView.animate(withDuration: 0.8, animations: {
                self.completionView.alpha = 1
                self.pathView.alpha = 0
                self.completionView.addSimpleShadow(color: UIColor.Main.berkshireLace, radius: 40, opacity: 0.6, offset: .zero)
            }, completion: { [weak self] _ in
                UIView.animate(withDuration: 0.4, animations: {
//                    self?.completionView.addSimpleShadow(color: UIColor.Main.berkshireLace, radius: 10, opacity: 0.3, offset: .zero)
                })
            })
        }
        
        pathView.layer.addSublayer(initialLayerLeft)
        pathView.layer.addSublayer(initialLayerRight)
    }
    
    // MARK:- Custom Methods
    
    private func setupUI() {
        
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        completionView.alpha = 0
        drawInitialPath()
    }
    
    private func loadFromNib() {
        
        Bundle.main.loadNibNamed("CompletionBlockView", owner: self, options: nil)
        
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
    }
}
