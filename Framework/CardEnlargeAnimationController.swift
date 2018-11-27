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
        guard let toVC = transitionContext.viewController(forKey: .to),
            let snapshotOfToVC = toVC.view.snapshotView(afterScreenUpdates: true),
            let snapshotOfOriginView = snapshotWithoutCornerRadius(view: originView) else {
            return
        }
        let containerView = transitionContext.containerView
        
        originView.isHidden = true
        toVC.view.isHidden = true
        
        snapshotOfToVC.resize(toFrameOfView: originView)
        snapshotOfOriginView.resize(toFrameOfView: originView)

        containerView.addSubview(snapshotOfToVC)
        containerView.addSubview(snapshotOfOriginView)
        
        animateCard(snapshotOfToVC: snapshotOfToVC, snapshotOfOriginView: snapshotOfOriginView, transitionContext: transitionContext)
        { _ in
            self.restoreViewState(toVC: toVC, snapshotOfToVC: snapshotOfToVC, snapshotOfOriginView: snapshotOfOriginView, containerView: containerView)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    fileprivate func snapshotWithoutCornerRadius(view: UIView) -> UIView? {
        let cornerRadius = view.layer.cornerRadius
        view.layer.cornerRadius = 0
        let snapshot = view.snapshotView(afterScreenUpdates: true)
        view.layer.cornerRadius = cornerRadius
        return snapshot
    }
    
    fileprivate func animateCard(snapshotOfToVC: UIView, snapshotOfOriginView: UIView, transitionContext: UIViewControllerContextTransitioning, completion: @escaping (Bool) -> ()) {
        guard let toVC = transitionContext.viewController(forKey: .to) else {
            return
        }
        let finalFrame = transitionContext.finalFrame(for: toVC)
        UIView.animateKeyframes(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: .calculationModeCubic,
            animations: {
                self.moveCardToTopFrame(snapshotOfToVC: snapshotOfToVC, snapshotOfOriginView: snapshotOfOriginView, screenFrame: transitionContext.containerView.frame)
                self.moveCardToFinalFrame(snapshotOfToVC: snapshotOfToVC, snapshotOfOriginView: snapshotOfOriginView, finalFrame: finalFrame)
        }, completion: completion)
    }
    
    fileprivate func moveCardToTopFrame(snapshotOfToVC: UIView, snapshotOfOriginView: UIView, screenFrame: CGRect) {
        UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/2) {
            // the animationns goes up first and then fills the screen. The position and size at the top is definded by topFrame
            let topFrame = CardAnimationValues.topFrame(cardViewFrame: self.originView.frame, screenFrame: screenFrame)
            
            snapshotOfToVC.frame = topFrame
            snapshotOfOriginView.frame = topFrame
        }
    }
    
    fileprivate func moveCardToFinalFrame(snapshotOfToVC: UIView, snapshotOfOriginView: UIView, finalFrame: CGRect) {
        UIView.addKeyframe(withRelativeStartTime: 1/2, relativeDuration: 1/2) {
            snapshotOfToVC.frame = finalFrame
            snapshotOfOriginView.frame = finalFrame
            
            snapshotOfToVC.layer.cornerRadius = 0
            snapshotOfOriginView.layer.cornerRadius = 0
            snapshotOfOriginView.alpha = 0
        }
    }
    
    fileprivate func restoreViewState(toVC: UIViewController, snapshotOfToVC: UIView, snapshotOfOriginView: UIView, containerView: UIView) {
        snapshotOfToVC.removeFromSuperview()
        snapshotOfOriginView.removeFromSuperview()
        
        toVC.view.isHidden = false
        self.originView.isHidden = false
        
        containerView.addSubview(toVC.view)
    }
}
