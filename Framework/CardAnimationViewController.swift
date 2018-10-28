//
//  CardAnimationViewController.swift
//  CardEnlargingTransition
//
//  Created by Jan Wasgint on 28.10.18.
//  Copyright © 2018 Jan Wasgint. All rights reserved.
//

import UIKit

class CardAnimationViewController: UIViewController & UIViewControllerTransitioningDelegate {
    private var cardView: UIView!
    private var snapshotOfCardView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transitioningDelegate = self
    }
    
    func cardEnlargeTransition(cardView: UIView, toVC: UIViewController) {
        self.cardView = cardView
        toVC.transitioningDelegate = self
    }
}

extension CardAnimationViewController {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let cornerRadiusOfCardView = cardView.layer.cornerRadius
        cardView.layer.cornerRadius = 0
        snapshotOfCardView = cardView.snapshotView(afterScreenUpdates: true)
        cardView.layer.cornerRadius = cornerRadiusOfCardView
        return CardEnlargeAnimationController(originView: cardView)
    }
    
    func animationController(forDismissed dismissed: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            guard let _ = dismissed as? PresentedViewController else {
                return nil
            }
            return CardShrinkAnimationController(destinationView: cardView, snapshotOfDestinationViewBeforePresentTransition: snapshotOfCardView, cardTopOffset: CGSize(width: cardView.frame.minX, height: cardView.frame.minY))
    }
}
