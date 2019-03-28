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
    
    // Fires BEFORE viewController's viewDidLoad()
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let vc = tabBarController.selectedViewController as? TodayViewController {
            let validationCheck = vc.isTodayVCFilledOutCompletely
            if !validationCheck {
                print("You have to fill out Today VC completely in order to change tabs")
            }
            return validationCheck
        }
        return true
    }
    
    // Fires AFTER viewController's viewDidLoad()
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        selectedTabView.moveToItem(selectedIndex)
    }
}
