//
//  CompletionBlockView.swift
//  FocusOn
//
//  Created by Rafal Padberg on 21.06.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import UIKit

class CompletionBlockView: UIView {
    
    // MARK:- Outlets
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var completionView: CompletionView!
    @IBOutlet var pulsatingShadowView: UIView!
    @IBOutlet var pathView: UIView!
    
    // MARK:- Private Properties
    
    private var parentConnection: TodayViewController!
    
    private var initialLayerLeft: CAShapeLayer = CAShapeLayer()
    private var initialLayerRight: CAShapeLayer = CAShapeLayer()
    private var pulsatingLayer: CAShapeLayer!
    
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
    
    // MARK:- Public Methods
    
    func config(parent: TodayViewController) {
        
        parentConnection = parent
    }
    
    func animateStart() {
        
        drawInitialPath()
    }
    
    // MARK:- PRIVATE
    // MARK:- Animation Methods
    
    private func animateCompletionAppearance() {
        
        let expandAnimation = CABasicAnimation.basicWith(keyPath: "strokeEnd", duration: 2)
        let shorteningAnimation = CABasicAnimation.basicWith(keyPath: "strokeStart", toValue: 0.5, duration: 0.8)

        initialLayerLeft.add(expandAnimation, forKey: nil)
        initialLayerRight.add(expandAnimation, forKey: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        
            self.initialLayerLeft.strokeStart = 0.5
            self.initialLayerRight.strokeStart = 0.5
            self.initialLayerLeft.add(shorteningAnimation, forKey: nil)
            self.initialLayerRight.add(shorteningAnimation, forKey: nil)
            
            UIView.animate(withDuration: 0.8, delay: 0.6, options: .curveEaseInOut, animations: {
                
                self.completionView.alpha = 1
                self.pathView.alpha = 0
            }, completion: { [weak self] _ in

                self?.pathView.isHidden = true
                self?.preparePulsatingLayer()
                self?.parentConnection.didFinishCompletionBlockAnimation()
            })
        }
    }
    
    private func animatePulsatingLayer() {
        
        UIView.animate(withDuration: 1.0, animations: {
            
            self.pulsatingShadowView.layer.opacity = 1.0
            self.pulsatingShadowView.addSimpleShadow(color: UIColor.Main.berkshireLace, radius: 20, opacity: 1, offset: .zero)
        }) { [weak self] _ in
            
            let pulsatingAnimation = CABasicAnimation.basicWith(keyPath: "opacity", fromValue: 1, toValue: 0.2, duration: 1, autoreverses: true, infinite: true)
            self?.pulsatingLayer.add(pulsatingAnimation, forKey: "pulsating")
        }
    }
    
    // MARK:- Layer and Path Methods
    
    private func drawInitialPath() {
        
        let width = bounds.width
        let height = bounds.height

        let leftPath = UIBezierPath()
        leftPath.move(to: CGPoint(x: 0, y: height / 2))
        leftPath.addLine(to: CGPoint(x: (width / 2) + 1 - (completionView.bounds.width / 2), y: height / 2))
        leftPath.addArc(withCenter: CGPoint(x: width / 2, y: height / 2), radius: completionView.bounds.height / 2 - 1, startAngle: CGFloat.pi, endAngle: CGFloat.pi - 0.01, clockwise: true)

        let rightPath = UIBezierPath()
        rightPath.move(to: CGPoint(x: width, y: height / 2))
        rightPath.addLine(to: CGPoint(x: (width / 2) - 1 + (completionView.bounds.width / 2), y: height / 2))
        rightPath.addArc(withCenter: CGPoint(x: width / 2, y: height / 2), radius: completionView.bounds.height / 2 - 1, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)

        initialLayerLeft.path = leftPath.cgPath
        setupLayer(initialLayerLeft)
        initialLayerRight.path = rightPath.cgPath
        setupLayer(initialLayerRight)
        
        pathView.layer.addSublayer(initialLayerLeft)
        pathView.layer.addSublayer(initialLayerRight)
        
        animateCompletionAppearance()
    }
    
    private func preparePulsatingLayer() {
        
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 39, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        pulsatingLayer = CAShapeLayer()
        pulsatingLayer.path = circularPath.cgPath
        pulsatingLayer.fillColor = UIColor.white.cgColor
        pulsatingLayer.lineCap = .round
        pulsatingLayer.position = CGPoint(x: pulsatingShadowView.bounds.midX,
                                          y: pulsatingShadowView.bounds.midY)
        
        pulsatingShadowView.layer.addSublayer(pulsatingLayer)
        pulsatingShadowView.layer.opacity = 0.2
        
        animatePulsatingLayer()
    }
    
    // MARK:- Custom Methods
    
    private func setupLayer(_ layer: CAShapeLayer) {
        
        layer.strokeColor = UIColor.Main.atlanticDeep.cgColor
        layer.fillColor = nil
        layer.lineWidth = lineWidth
    }
    
    private func setupUI() {
        
        completionView.alpha = 0
    }
    
    private func loadFromNib() {
        
        Bundle.main.loadNibNamed("CompletionBlockView", owner: self, options: nil)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        addSubview(contentView)
    }
    
    // MARK:- Action Methods
    
    @IBAction func completionViewTapped(_ button: UIButton) {
        
        parentConnection.changeCompletion()
    }
    
    var x = true
    
    @IBAction func notYetCompletedTapped(_ button: UIButton) {
        
        parentConnection.changeCompletionToNYA()
//        completionView.toggleNotYetAchieved()
    }
}
