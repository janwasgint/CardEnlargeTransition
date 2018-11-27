//
//  HelperExtensions.swift
//  CardEnlargingTransition
//
//  Created by Jan Wasgint on 27.11.18.
//  Copyright © 2018 Jan Wasgint. All rights reserved.
//

import UIKit

extension UIView {
    func resize(toFrameOfView goalView: UIView) {
        frame = goalView.frame
        layer.masksToBounds = true
        layer.cornerRadius = goalView.layer.cornerRadius
    }
}
