//
//  CustomTabBarItemView.swift
//  FocusOn
//
//  Created by Rafal Padberg on 14.03.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import UIKit

class CustomTabBarItemView: UIView {
    
    var itemWidth: CGFloat = 0
    
    func prepareView(in tabBar: UITabBar) {
        itemWidth = tabBar.frame.size.width / 3
        let itemHeight = tabBar.frame.size.height
        
        self.frame = CGRect(x: itemWidth + 1, y: tabBar.frame.origin.y + 1
            , width: itemWidth - 2, height: itemHeight - 2)
        self.backgroundColor = UIColor.lightGray.withAlphaComponent(0.25)
        self.isUserInteractionEnabled = false
    }
    
    func moveToItem(_ itemId: Int) {
        self.frame.origin.x = itemWidth * CGFloat(itemId) + 1
    }
}
