//
//  UIView+effects.swift
//  FocusOn
//
//  Created by Rafal Padberg on 20.05.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import UIKit

extension UIView {
    
    func addSimpleShadow(color: UIColor, radius: CGFloat, opacity: Float, offset: CGSize) {
        
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
    }
    
    func roundCorners(corners: UIRectCorner, radius: Int) {
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
    
    func addHorizontalGradient(of colors: [UIColor]) {
        let layer = CAGradientLayer()
        layer.frame = self.bounds
        layer.colors = colors.map { $0.cgColor }
        
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 0)
        self.layer.addSublayer(layer)
    }
    
    func addVerticalGradient(of colors: [UIColor]) {
        let layer = CAGradientLayer()
        layer.frame = self.bounds
        layer.colors = colors.map { $0.cgColor }
        
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 0, y: 1)
        self.layer.insertSublayer(layer, at: 0)
    }
    
    func addDiagonalGradient(of colors: [UIColor]) {
        
        let layer = CAGradientLayer()
        layer.frame = self.bounds
        layer.colors = colors.map { $0.cgColor }
        
        layer.startPoint = CGPoint(x: 1, y: 0)
        layer.endPoint = CGPoint(x: 0, y: 1)
        self.layer.insertSublayer(layer, at: 0)
    }
}
