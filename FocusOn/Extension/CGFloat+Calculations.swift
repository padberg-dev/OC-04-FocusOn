//
//  CGFloat+Calculations.swift
//  FocusOn
//
//  Created by Rafal Padberg on 20.06.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import UIKit

extension CGFloat {
    
    func returnInRange(minValue: CGFloat, maxValue: CGFloat) -> CGFloat {
        
        return Swift.min(maxValue, Swift.max(minValue, self))
    }
}
