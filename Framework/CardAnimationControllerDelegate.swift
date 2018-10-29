//
//  CardAnimationControllerDelegate.swift
//  CardEnlargingTransition
//
//  Created by Jan Wasgint on 29.10.18.
//  Copyright © 2018 Jan Wasgint. All rights reserved.
//

import UIKit

class CardAnimationControllerDelegate {
    private var _tabBar: UIView?
    private var _navigationBar: UIView?
    
    func setTabBar(tabBar: UIView) {
        _tabBar = tabBar
    }
    func tabBar() -> UIView? {
        return _tabBar
    }
    
    func setNavigationBar(navigationBar: UIView) {
        _navigationBar = navigationBar
    }
    func navigationBar() -> UIView? {
        return _navigationBar
    }
}
