//
//  CardAnimationValues.swift
//  CardEnlargingTransition
//
//  Created by Jan Wasgint on 28.10.18.
//  Copyright © 2018 Jan Wasgint. All rights reserved.
//

import UIKit

final class CardAnimationValues {
    static let cardCornerRadius: CGFloat = 15
    static let cardAnimationDuration: TimeInterval = 10
    
    static func topFrame(cardViewFrame: CGRect, containerView: UIView) -> CGRect {
        let sideInset = cardViewFrame.minX * 0.4
        let topInset: CGFloat = 0
        let topFrameWidth = containerView.frame.width - 2 * sideInset
        let topFrameHeight = (cardViewFrame.height + containerView.frame.height) * 0.5
        
        let topFrame = CGRect(x: sideInset, y: topInset, width: topFrameWidth, height: topFrameHeight)
        
        return topFrame
    }
}
