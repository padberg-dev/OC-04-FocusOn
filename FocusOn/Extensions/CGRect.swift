//
//  CGRect.swift
//  FocusOn
//
//  Created by Rafal Padberg on 25.07.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import UIKit

extension CGRect {
    
    func extendBy(xFactor: CGFloat, yFactor: CGFloat) -> CGRect {
        
        var rect = CGRect()
        let newWidth = self.width * xFactor
        let newHeight = self.height * yFactor
        
        rect.size.width = newWidth
        rect.size.height = newHeight
        rect.origin.x -= (newWidth - width) / 2 + origin.x
        rect.origin.y -= (newHeight - height) / 2 + origin.y
        return rect
    }
    
    func moveBy(width: CGFloat, height: CGFloat) -> CGRect {
        
        var rect = self
        rect.origin.x = self.origin.x + width * self.size.width
        rect.origin.y = self.origin.y + height * self.size.height
        
        return rect
    }
}
