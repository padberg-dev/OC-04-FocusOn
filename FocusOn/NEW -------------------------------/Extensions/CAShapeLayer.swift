//
//  CAShapeLayer.swift
//  FocusOn
//
//  Created by Rafal Padberg on 17.08.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import UIKit

extension CAShapeLayer {
    
    static func basicWith(path: CGPath, strokeColor: CGColor = UIColor.Main.berkshireLace.cgColor, fillColor: CGColor? = nil, lineWidth: CGFloat? = 4.0) -> CAShapeLayer {
        
        let layer = CAShapeLayer()
        layer.path = path
        layer.strokeColor = strokeColor
        layer.fillColor = fillColor
        layer.lineWidth = 4.0
        
        return layer
    }
    
}
