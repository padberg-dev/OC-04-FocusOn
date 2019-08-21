//
//  CATransform3D.swift
//  FocusOn
//
//  Created by Rafal Padberg on 21.08.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import UIKit

extension CATransform3D {
    
    static func transform(angleInDeggres: CGFloat, xAxis: Bool = false, yAxis: Bool = false) -> CATransform3D {
        
        var identity = CATransform3DIdentity
        // Positive makes the transform shrink(away from screen) and negative expand(closer to screen)
        identity.m34 = 1.0 / 1000.0
        
        let angle = -angleInDeggres * CGFloat.pi / 180
        let rotateTransform = CATransform3DRotate(identity, angle, xAxis ? 1 : 0, yAxis ? 1 : 0, 0)
        
        return rotateTransform
    }
}
