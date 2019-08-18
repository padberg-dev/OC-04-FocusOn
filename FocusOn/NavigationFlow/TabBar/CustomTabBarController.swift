//
//  CustomTabBarController.swift
//  FocusOn
//
//  Created by Rafal Padberg on 04.03.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    // MARK:- Private Properties
    
    private let selectedTabView = CustomTabBarItemView()
    private let transitionAnimator = SlideInTransitionAnimator()
    private let tabBarData: [String] = ["history", "today", "progress"]
    private let tabBarVCs: [ViewControllerNames] = [.history, .today, .progress]
    
    private var shouldDelayTabBarAnimation: Bool = false
    
    // MARK:- View Controller's Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegates()
        initializeViewControllers()
        prepareTabBar()
    }
    
    // MARK:- PRIVATE
    // MARK:- Custom Methods
    
    private func setupDelegates() {
        delegate = self
    }
    
    private func initializeViewControllers() {
        
        let historyVC = UIStoryboard(name: "HistoryVC", bundle: nil).instantiateInitialViewController() as! HistoryViewController
        let todayVC = UIStoryboard(name: "TodayVC", bundle: nil).instantiateInitialViewController() as! TodayViewController
        let progressVC = UIStoryboard(name: "ProgressVC", bundle: nil).instantiateInitialViewController() as! ProgressViewController
        
        assignTabBarItem(to: historyVC, with: tabBarData[0])
        assignTabBarItem(to: todayVC, with: tabBarData[1])
        assignTabBarItem(to: progressVC, with: tabBarData[2])
        
        // After assigning view controllers to tabBarController.viewController the first item in the array will be loaded. In order to have the first active view controller be of index 1, without loading VC with index 0, the array has to be split so that the wanted VC has the index 0 and all VC's before it have to be inserted into the array afterwards.
        viewControllers = [todayVC, progressVC]
        viewControllers?.insert(historyVC, at: 0)
        
        selectedIndex = 1
    }
    
    private func prepareTabBar() {
        
        selectedTabView.prepare(in: tabBar)
        tabBar.addSubview(selectedTabView)
        
        tabBar.isTranslucent = false
        tabBar.unselectedItemTintColor = UIColor.Main.deepPeacoockBlue
        tabBar.tintColor = UIColor.Main.atlanticDeep
        tabBar.barTintColor = UIColor.Main.berkshireLace
    }
    
    private func assignTabBarItem(to viewController: UIViewController, with imageName: String) {
        
        if let image = UIImage(named: imageName) {
            viewController.tabBarItem.image = image
        }
        viewController.title = imageName.capitalized
    }
}

// MARK:- UITabBarControllerDelegate Methods
extension CustomTabBarController: UITabBarControllerDelegate {
    
    // Fires BEFORE viewController's viewDidLoad()
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if let vc = tabBarController.selectedViewController as? TodayViewController {
            let validationCheck = vc.isTodayVCFilledOutCompletely
            return validationCheck
        } else {
            return true
        }
    }
    
    // Fires AFTER viewController's viewDidLoad()
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        if shouldDelayTabBarAnimation {
            selectedTabView.animateTo(tabBarId: selectedIndex, delayBy: 1.4)
            shouldDelayTabBarAnimation = false
        } else {
            selectedTabView.animateTo(tabBarId: selectedIndex)
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if let fromIndex = viewControllers?.firstIndex(of: fromVC) {
            
            if let toIndex = viewControllers?.firstIndex(of: toVC) {
                
                if tabBarVCs[fromIndex] == .today && tabBarVCs[toIndex] == .history {
                    
                    if let vc = toVC as? HistoryViewController {
                        
                        transitionAnimator.shouldAnimateSliding = vc.shouldAnimateSliding
                        transitionAnimator.shouldSlideToSelectedCell = vc.isFirstCellSelected
                        shouldDelayTabBarAnimation = vc.shouldAnimateSliding
                    }
                }
                transitionAnimator.isSlidingToTheLeft = fromIndex > toIndex
            }
        }
        return transitionAnimator
    }
}
