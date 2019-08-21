//
//  SlideInTransitionAnimator.swift
//  FocusOn
//
//  Created by Rafal Padberg on 21.06.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import UIKit

class SlideInTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    private let rightEdgeOffset: CGFloat = 26
    private var duration: Double = 0.8
    
    var isSlidingToTheLeft: Bool = false
    var shouldSlideToSelectedCell: Bool = false
    var shouldAnimateSliding: Bool = false {
        willSet(newValue) {
            duration = newValue ? 2 : 0.8
        }
    }
    
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
        let container = transitionContext.containerView
        container.addSubview(fromView)
        container.addSubview(toView)
        
        let dX = isSlidingToTheLeft ? -container.frame.width : container.frame.width
        toView.transform = CGAffineTransform(translationX: dX, y: 0)
        
        if shouldAnimateSliding {

            guard let goalView = fromView.subviews[0].subviews[0].subviews.last as? GoalBlockView else { return }
            guard let historyInsertionView = toView.subviews[0].subviews.last else { return }
            guard let startPositionView = toView.subviews[0].subviews.first else { return }
            
            goalView.alpha = 0
            let width = UIScreen.main.bounds.width
            let dY = startPositionView.frame.origin.y - historyInsertionView.frame.origin.y
            
            let goalData = goalView.getGoalData()
            let copiedGoal = GoalBlockView(frame: CGRect(origin: CGPoint(x: width, y: 0), size: CGSize(width: width, height: goalView.frame.height)))
            copiedGoal.update(title: goalData.title, dateString: goalData.dateString, completion: goalData.completion)
            copiedGoal.transform = CGAffineTransform(translationX: 0, y: dY)
            copiedGoal.animateTransition()
            
            historyInsertionView.addSubview(copiedGoal)
            
            let halfDuration = duration / 2
            let slideToSelectedCell = self.shouldSlideToSelectedCell
            
            UIView.animate(withDuration: halfDuration, animations: {
                
                copiedGoal.transform = .identity
            }) { [weak self] _ in
                
                UIView.animate(withDuration: halfDuration, animations: {
                    
                    copiedGoal.frame.origin.x = 0
                    copiedGoal.imageViewRightConstraint.constant += slideToSelectedCell ? 52 : 26
                    copiedGoal.bottomLineRightConstraint.constant -= slideToSelectedCell ? 0 : 26
                    copiedGoal.layoutIfNeeded()
                    copiedGoal.bottomLineView.frame.size.width -= 26
                    copiedGoal.backgroundView.frame.size.width -= 26
                    
                    fromView.subviews[0].transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                    
                    toView.transform = CGAffineTransform.identity
                    historyInsertionView.frame.origin.x = slideToSelectedCell ? 26 : 0
                    
                }, completion: { _ in
                    
                    copiedGoal.removeFromSuperview()
                    fromView.subviews[0].transform = .identity
                    transitionContext.completeTransition(true)
                    self?.shouldAnimateSliding = false
                    goalView.alpha = 1
                })
            }
        }
        else {
            
            // Basic Transition
            UIView.animate(withDuration: duration, animations: {
                
                fromView.subviews[0].transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                toView.transform = CGAffineTransform.identity
            }, completion: { _ in
                
                fromView.subviews[0].transform = .identity
                transitionContext.completeTransition(true)
            })
        }
    }
}
