//
//  CABasicAnimation.swift
//  FocusOn
//
//  Created by Rafal Padberg on 16.08.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import UIKit

extension CABasicAnimation {
    
    static func basicWith(keyPath: String, fromValue: Double = 0, toValue: Double = 1, duration: Double, autoreverses: Bool = false, infinite: Bool = false) -> CABasicAnimation {
        
        let basicAnimation = CABasicAnimation(keyPath: keyPath)
        basicAnimation.fromValue = fromValue
        basicAnimation.toValue = toValue
        basicAnimation.duration = duration
        basicAnimation.autoreverses = autoreverses
        basicAnimation.repeatCount = infinite ? .infinity : 1
        
        return basicAnimation
    }
}
