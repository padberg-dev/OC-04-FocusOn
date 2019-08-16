//
//  CustomTabBarItemView.swift
//  FocusOn
//
//  Created by Rafal Padberg on 14.03.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import UIKit

class CustomTabBarItemView: UIView {
    
    private var itemWidth: CGFloat = 0
    
    func prepare(in tabBar: UITabBar) {
        
        itemWidth = tabBar.bounds.size.width / 3
        let itemHeight = tabBar.bounds.size.height
        
        self.frame = CGRect(x: itemWidth + 1, y: 1, width: itemWidth - 2, height: itemHeight - 2)
        self.backgroundColor = UIColor.Main.deepPeacoockBlue.withAlphaComponent(0.2)
        self.isUserInteractionEnabled = false
        
        tabBar.addSimpleShadow(color: UIColor.Main.rosin, radius: 3.0, opacity: 0.3, offset: .zero)
    }
    
    func animateTo(tabBarId: Int, delayBy: Double = 0) {
        
        if delayBy > 0 {
            
            UIView.animate(withDuration: Settings.AnimationDurations.tabBar, delay: delayBy, options: .curveEaseIn, animations: {
                self.frame.origin.x = self.itemWidth * CGFloat(tabBarId) + 1
            }, completion: nil)
        } else {
            
            UIView.animate(withDuration: Settings.AnimationDurations.tabBar) {
                self.frame.origin.x = self.itemWidth * CGFloat(tabBarId) + 1
            }
        }
    }
}
