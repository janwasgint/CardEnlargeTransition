//
//  CardEnlargeAnimationController.swift
//  CardEnlargingTransition
//
//  Created by Jan Wasgint on 19.10.18.
//  Copyright © 2018 Jan Wasgint. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideTabBar() {
        if let originalFrame = self.tabBarController?.tabBar.frame {
            let newFrame = originalFrame.offsetBy(dx: 0, dy: originalFrame.size.height)
            UIView.animate(withDuration: CardAnimationValues.cardAnimationDuration, animations: {
                self.tabBarController?.tabBar.frame = newFrame
            })
        }
    }
    
    func showTabBar() {
        if let originalFrame = self.tabBarController?.tabBar.frame {
            let newFrame = originalFrame.offsetBy(dx: 0, dy: -originalFrame.size.height)
            UIView.animate(withDuration: CardAnimationValues.cardAnimationDuration, animations: {
                self.tabBarController?.tabBar.frame = newFrame
            })
        }
    }
}

class CardEnlargeAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let originView: UIView
    var delegate: CardAnimationControllerDelegate?
    
    init(originView: UIView) {
        self.originView = originView
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return CardAnimationValues.cardAnimationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let originViewCornerRadius = originView.layer.cornerRadius
        originView.layer.cornerRadius = 0
        
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to),
            let snapshotOfToVC = toVC.view, //.snapshotView(afterScreenUpdates: true),
            let snapshotOfOriginView = originView.snapshotView(afterScreenUpdates: false)
            else {
                originView.layer.cornerRadius = originViewCornerRadius
                return
        }
        let containerView = transitionContext.containerView

        fromVC.view.removeFromSuperview()
        toVC.view.removeFromSuperview()
        
        originView.layer.cornerRadius = originViewCornerRadius

        containerView.backgroundColor = fromVC.view.backgroundColor
        let finalFrame = transitionContext.finalFrame(for: toVC)
        
        containerView.addSubview(toVC.view)
        
        snapshotOfToVC.frame = originView.frame
        snapshotOfToVC.layer.cornerRadius = CardAnimationValues.cardCornerRadius
        snapshotOfToVC.layer.masksToBounds = true

        snapshotOfOriginView.layer.cornerRadius = CardAnimationValues.cardCornerRadius
        snapshotOfOriginView.layer.masksToBounds = true
        containerView.addSubview(snapshotOfOriginView)
        snapshotOfOriginView.frame = originView.frame

        let duration = transitionDuration(using: transitionContext)

        fromVC.hideTabBar()
        
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
                let transitionSuccessful = !transitionContext.transitionWasCancelled
                transitionContext.completeTransition(transitionSuccessful)
                containerView.addSubview(toVC.view)
                self.originView.isHidden = false
        })
    }
}
