//
//  CustomTabBarController.swift
//  FocusOn
//
//  Created by Rafal Padberg on 04.03.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var selectedTabView = CustomTabBarItemView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        selectedTabView.prepareView(in: tabBar)
        self.view.addSubview(selectedTabView)
        tabBar.isTranslucent = false
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let id = tabBar.items?.firstIndex(of: item)
        selectedTabView.moveToItem(id!)
    }
    
    // Fires BEFORE viewController's viewDidLoad()
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
    
    // Fires AFTER viewController's viewDidLoad()
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
    }
}
