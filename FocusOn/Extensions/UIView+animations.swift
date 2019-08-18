//
//  UIView+animations.swift
//  FocusOn
//
//  Created by Rafal Padberg on 21.07.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import UIKit

extension UIView {
    
    func animateAppearing(duration: Double = Settings.AnimationDurations.viewAppearing) {
        
        UIView.animate(withDuration: duration) {
            self.alpha = 1
        }
    }
    
    func animateDisappearing(duration: Double = Settings.AnimationDurations.viewAppearing) {
        
        UIView.animate(withDuration: duration) {
            self.alpha = 0
        }
    }
    
    func rotate(duration: CFTimeInterval = 1.0, fromValue: CGFloat = 0.0, toValue: CGFloat = 0.0) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = fromValue
        rotateAnimation.toValue = toValue
        rotateAnimation.duration = duration
        
        self.layer.add(rotateAnimation, forKey: nil)
    }
}
