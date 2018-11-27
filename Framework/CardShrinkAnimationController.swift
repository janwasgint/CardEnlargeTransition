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
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to),
            let snapshotOfFromVC = fromVC.view.snapshotView(afterScreenUpdates: false)
            else {
                return
        }
        let containerView = transitionContext.containerView
        
        destinationView.isHidden = true
        fromVC.view.isHidden = true
        
        snapshotOfDestinationView.resize(toFrameOfView: snapshotOfFromVC)
        
        snapshotOfFromVC.layer.masksToBounds = true
        
        containerView.insertSubview(toVC.view, at: 0)
        containerView.addSubview(snapshotOfDestinationView)
        containerView.addSubview(snapshotOfFromVC)
        
        animateCard(snapshotOfFromVC: snapshotOfFromVC, transitionContext: transitionContext) { _ in
            self.restoreViewState(snapshotOfFromVC: snapshotOfFromVC, fromVC: fromVC)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    fileprivate func animateCard(snapshotOfFromVC: UIView, transitionContext: UIViewControllerContextTransitioning, completion: @escaping (Bool) -> ()) {
        let containerView = transitionContext.containerView
        UIView.animateKeyframes(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: .calculationModeCubic,
            animations: {
                self.moveCardToTopFrame(snapshotOfFromVC: snapshotOfFromVC, screenFrame: containerView.frame)
                self.moveCardToFinalFrame(snapshotOfFromVC: snapshotOfFromVC)
        },
            completion: completion)
    }
    
    fileprivate func moveCardToTopFrame(snapshotOfFromVC: UIView, screenFrame: CGRect) {
        UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/2) {
            let topFrame = CardAnimationValues.topFrame(cardViewFrame: self.originalFrameOfDestinationView, screenFrame: screenFrame)
            
            self.snapshotOfDestinationView.frame = topFrame
            self.snapshotOfDestinationView.layer.cornerRadius = CardAnimationValues.cardCornerRadius
            
            snapshotOfFromVC.frame = topFrame
            snapshotOfFromVC.layer.cornerRadius = CardAnimationValues.cardCornerRadius
            snapshotOfFromVC.alpha = 0
        }
    }
    
    fileprivate func moveCardToFinalFrame(snapshotOfFromVC: UIView) {
        UIView.addKeyframe(withRelativeStartTime: 1/2, relativeDuration: 1/2) {
            snapshotOfFromVC.frame = self.originalFrameOfDestinationView
            self.snapshotOfDestinationView.frame = self.originalFrameOfDestinationView
        }
    }
    
    fileprivate func restoreViewState(snapshotOfFromVC: UIView, fromVC: UIViewController) {
        snapshotOfFromVC.removeFromSuperview()
        self.snapshotOfDestinationView.removeFromSuperview()
        
        fromVC.view.isHidden = false
        self.destinationView.isHidden = false
    }
}
