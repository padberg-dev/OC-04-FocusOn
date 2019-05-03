//
//  StartFactory.swift
//  FocusOn
//
//  Created by Rafal Padberg on 10.03.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import UIKit

class StartFactory {
    
    static func showIn(window: UIWindow) {
        
        let navigationController = UINavigationController()
        
//        GoalData.createYesterdayScenario()
//        GoalData.createALotOfDataScenario(numberOfDays: 1200)
        
        let historyVC = UIStoryboard(name: "HistoryVC", bundle: nil).instantiateInitialViewController() as! HistoryViewController
        let todayVC = UIStoryboard(name: "TodayVC", bundle: nil).instantiateInitialViewController() as! TodayViewController
        todayVC.todayVM = TodayViewModel.loadFromCoreData()
        let progressVC = UIStoryboard(name: "ProgressVC", bundle: nil).instantiateInitialViewController() as! ProgressViewController
        
        let tabBarController = CustomTabBarController()
        tabBarController.viewControllers = [todayVC, progressVC]
        // After assigning view controllers to tabBarController.viewController the first item in the array will be loaded. In order to have the first active view controller be of index 1, without loading VC with index 0, the array has to be split so that the wanted VC has the index 0 and all VC's before it has to be inserted into the array afterwards.
        tabBarController.viewControllers?.insert(historyVC, at: 0)
        tabBarController.selectedIndex = 1
        
        navigationController.setViewControllers([tabBarController], animated: false)
        window.rootViewController = navigationController
    }
}
