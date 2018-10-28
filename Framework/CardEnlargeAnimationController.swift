//
//  CardEnlargeAnimationController.swift
//  CardEnlargingTransition
//
//  Created by Jan Wasgint on 19.10.18.
//  Copyright © 2018 Jan Wasgint. All rights reserved.
//

import UIKit

class CardEnlargeAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let originView: UIView
    
    init(originView: UIView) {
        self.originView = originView
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return CardAnimationValues.cardAnimationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let originViewCornerRadius = originView.layer.cornerRadius
        originView.layer.cornerRadius = 0
        guard let toVC = transitionContext.viewController(forKey: .to),
            let snapshotOfToVC = toVC.view.snapshotView(afterScreenUpdates: true),
            let snapshotOfOriginView = originView.snapshotView(afterScreenUpdates: true)
            else {
                originView.layer.cornerRadius = originViewCornerRadius
                return
        }
        originView.layer.cornerRadius = originViewCornerRadius
        
        let containerView = transitionContext.containerView
        containerView.backgroundColor = .white
        let finalFrame = transitionContext.finalFrame(for: toVC)
        
        snapshotOfToVC.frame = originView.frame
        snapshotOfToVC.layer.cornerRadius = 15
        snapshotOfToVC.layer.masksToBounds = true
        
        
        containerView.addSubview(snapshotOfToVC)
        toVC.view.isHidden = true
        
        snapshotOfOriginView.layer.cornerRadius = 15
        snapshotOfOriginView.layer.masksToBounds = true
        containerView.addSubview(snapshotOfOriginView)
        snapshotOfOriginView.frame = originView.frame
        
        originView.isHidden = true
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: .calculationModeCubic,
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/2) {
                    let topFrame = CardAnimationValues.topFrame(cardViewFrame: self.originView.frame, containerView: containerView)
                    
                    snapshotOfToVC.frame = topFrame
                    snapshotOfOriginView.frame = topFrame
                }
                
                UIView.addKeyframe(withRelativeStartTime: 1/2, relativeDuration: 1/2) {
                
                    snapshotOfToVC.frame = finalFrame
                    snapshotOfToVC.layer.cornerRadius = 0
                    
                    snapshotOfOriginView.frame = finalFrame
                    snapshotOfOriginView.layer.cornerRadius = 0
                    snapshotOfOriginView.alpha = 0
                }
        },
            completion: { _ in
                toVC.view.isHidden = false
                snapshotOfToVC.removeFromSuperview()
                snapshotOfOriginView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                containerView.addSubview(toVC.view)
                self.originView.isHidden = false
        })
    }
    
    
}
