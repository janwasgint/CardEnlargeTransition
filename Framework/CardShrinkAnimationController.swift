//
//  CardShrinkAnimationController.swift
//  CardEnlargingTransition
//
//  Created by Jan Wasgint on 20.10.18.
//  Copyright © 2018 Jan Wasgint. All rights reserved.
//

import UIKit

class CardShrinkAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let destinationView: UIView // necessary because we need a handle to the real view to hide it during the transition and show it again afterwards
    private let snapshotOfDestinationView: UIView // necessary because we need a version of the destination view after view did load (captured before present transition)
    private let originalFrameOfDestinationView: CGRect
    
    init(destinationView: UIView, snapshotOfDestinationViewBeforePresentTransition: UIView, cardTopOffset: CGSize) {
        self.destinationView = destinationView
        self.snapshotOfDestinationView = snapshotOfDestinationViewBeforePresentTransition
        originalFrameOfDestinationView = snapshotOfDestinationViewBeforePresentTransition.frame.offsetBy(dx: cardTopOffset.width, dy: cardTopOffset.height)
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return CardAnimationValues.cardAnimationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        destinationView.isHidden = true
        let containerView = transitionContext.containerView
        
        containerView.addSubview(snapshotOfDestinationView)
        snapshotOfDestinationView.layer.cornerRadius = 0
        snapshotOfDestinationView.frame = containerView.frame
        
        
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to),
            let snapshotOfFromVC = fromVC.view.snapshotView(afterScreenUpdates: false)
            else {
                return
        }
        
        snapshotOfFromVC.layer.masksToBounds = true
        
        containerView.insertSubview(toVC.view, at: 0)
        containerView.addSubview(snapshotOfDestinationView)
        containerView.addSubview(snapshotOfFromVC)
        
        snapshotOfDestinationView.layer.masksToBounds = true
        snapshotOfDestinationView.frame = snapshotOfFromVC.frame
        
        fromVC.view.isHidden = true
        
        toVC.showTabBar()
        
        let duration = transitionDuration(using: transitionContext)
                
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: .calculationModeCubic,
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/2) {
                    
                    let topFrame = CardAnimationValues.topFrame(cardViewFrame: self.originalFrameOfDestinationView, containerView: containerView)
                    
                    snapshotOfFromVC.frame = topFrame
                    self.snapshotOfDestinationView.frame = topFrame
                    
                    snapshotOfFromVC.layer.cornerRadius = CardAnimationValues.cardCornerRadius
                    snapshotOfFromVC.alpha = 0
                    self.snapshotOfDestinationView.layer.cornerRadius = CardAnimationValues.cardCornerRadius
                }

                UIView.addKeyframe(withRelativeStartTime: 1/2, relativeDuration: 1/2) {
                    snapshotOfFromVC.frame = self.originalFrameOfDestinationView
                    self.snapshotOfDestinationView.frame = self.originalFrameOfDestinationView
                }
        },
            completion: { _ in
                fromVC.view.isHidden = false
                snapshotOfFromVC.removeFromSuperview()
                self.snapshotOfDestinationView.removeFromSuperview()
                self.destinationView.isHidden = false
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
