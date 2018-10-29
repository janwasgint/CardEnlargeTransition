//
//  CardAnimationViewController.swift
//  CardEnlargingTransition
//
//  Created by Jan Wasgint on 28.10.18.
//  Copyright © 2018 Jan Wasgint. All rights reserved.
//

import UIKit

class CardAnimationViewController: NSObject, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
    private var cardView: UIView!
    private var snapshotOfCardView: UIView!
    private var pushAnimator: UIViewControllerAnimatedTransitioning!
    private var popAnimator: UIViewControllerAnimatedTransitioning!
    private var initialDepth: Int = 0
    private var cardAnimationControllerDelegate: CardAnimationControllerDelegate!
    
    static var animations = [CardAnimationViewController]()
    
    
    static func setup(cardView: UIView, segue: UIStoryboardSegue) {
        let animation = CardAnimationViewController()
        
        animation.cardView = cardView
        segue.source.transitioningDelegate = animation
        segue.destination.transitioningDelegate = animation
        animation.cardAnimationControllerDelegate = CardAnimationControllerDelegate()
        
        animations.append(animation)
    }
    
    static func setup(cardView: UIView, fromVC: UIViewController, navigationController: UINavigationController) {
        let animation = CardAnimationViewController()
        
        animation.cardView = cardView
        navigationController.delegate = animation
        animation.cardAnimationControllerDelegate = CardAnimationControllerDelegate()
        animation.pushAnimator = animation.animationController(forPresented: UIViewController(), presenting: UIViewController(), source: UIViewController())!
        animation.popAnimator = animation.animationController(forDismissed: UIViewController())!
        animation.initialDepth = navigationController.depth(ofViewController: fromVC) ?? 0
        
        animations.append(animation)
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        
        if operation == .pop {
            if navigationController.depth(ofViewController: toVC) == 0 {
                return popAnimator
            }
        } else {
            if navigationController.depth(ofViewController: fromVC) == 0 {
                return pushAnimator
            }
        }
        
        return nil
    }
}

extension CardAnimationViewController {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let cornerRadiusOfCardView = cardView.layer.cornerRadius
        cardView.layer.cornerRadius = 0
        snapshotOfCardView = cardView.snapshotView(afterScreenUpdates: true)
        cardView.layer.cornerRadius = cornerRadiusOfCardView
        let enlargeAnimationController = CardEnlargeAnimationController(originView: cardView)
        enlargeAnimationController.delegate = cardAnimationControllerDelegate
        return enlargeAnimationController
    }
    
    func animationController(forDismissed dismissed: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
        let shrinkAnimationController = CardShrinkAnimationController(destinationView: cardView, snapshotOfDestinationViewBeforePresentTransition: snapshotOfCardView, cardTopOffset: CGSize(width: cardView.frame.minX, height: cardView.frame.minY))
        shrinkAnimationController.delegate = cardAnimationControllerDelegate
        return shrinkAnimationController
    }
}


extension UINavigationController {
    func depth(ofViewController searchedViewController: UIViewController) -> Int? {
        var i = 0;
        for viewController in viewControllers {
            if (viewController === searchedViewController) {
                return i
            }
            i += 1
        }
        return nil
    }
}

