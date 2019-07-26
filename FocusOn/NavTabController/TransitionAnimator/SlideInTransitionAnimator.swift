//
//  SlideInTransitionAnimator.swift
//  FocusOn
//
//  Created by Rafal Padberg on 21.06.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import UIKit

class SlideInTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    var duration = 4.0
    var toTheLeft: Bool = true
    var isFirstTime: Bool = true
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // Get reference to our fromView, toView and the container view
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
            return
        }
        
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
            return
        }
        print("ANIMATE \(isFirstTime)")
        
        if isFirstTime { duration = 2.0 } else { duration = 0.8 }
        
        let container = transitionContext.containerView
        
        let dX = toTheLeft ? -container.frame.width : container.frame.width
        let offScreenLeft = CGAffineTransform(translationX: dX, y: 0)
        
        toView.transform = offScreenLeft
        
        container.addSubview(fromView)
        container.addSubview(toView)
        
        if isFirstTime {
            
            let table = toView.subviews[0] as? UITableView
            let cell = table?.cellForRow(at: IndexPath(row: 0, section: 0))
            print(table?.frame)
            let yOrigin = cell!.frame.origin.y + 64
            
            var newGoal: GoalBlockView!
            
            print("TERAZ")
            if let goalView = fromView.subviews[0].subviews[0].subviews.last as? GoalBlockView {
                print("TERAZ UDAŁO SIĘ")
                goalView.alpha = 0
                let width = UIScreen.main.bounds.width
                newGoal = GoalBlockView(frame: CGRect(origin: CGPoint(x: width, y: goalView.frame.origin.y + 64), size: CGSize(width: width, height: 60)))
                toView.addSubview(newGoal)
                newGoal.setCompletion(to: goalView.completionProgress)
                newGoal.changeLabels(title: goalView.goalLabel.text!, date: goalView.dateLabel.text!)
                newGoal.animateTransition()
            }
            
            UIView.animate(withDuration: duration / 2, animations: {
                newGoal.frame.origin.y = yOrigin
            }) { _ in
                UIView.animate(withDuration: self.duration / 2, animations: {
                    newGoal.imageViewRightConstraint.constant += 26
                    newGoal.layoutIfNeeded()
                    newGoal.backgroundView.frame.size.width -= 26
                    fromView.subviews[0].transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                    toView.transform = CGAffineTransform.identity
                    toView.subviews.last?.frame.origin.x = 0
                }, completion: { _ in
                    newGoal.removeFromSuperview()
                    fromView.subviews[0].transform = .identity
                    transitionContext.completeTransition(true)
                    self.isFirstTime = false
                    if let goalView = fromView.subviews[0].subviews[0].subviews.last as? GoalBlockView {
                        goalView.alpha = 1
                    }
                })
            }
        } else {
            UIView.animate(withDuration: self.duration / 2, animations: {
                fromView.subviews[0].transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                toView.transform = CGAffineTransform.identity
                toView.subviews.last?.frame.origin.x = 0
            }, completion: { _ in
                fromView.subviews[0].transform = .identity
                transitionContext.completeTransition(true)
            })
        }
    }
}
