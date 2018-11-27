//
//  ViewController.swift
//  CardEnlargingTransition
//
//  Created by Jan Wasgint on 19.10.18.
//  Copyright © 2018 Jan Wasgint. All rights reserved.
//

import UIKit

class ViewController: CardAnimationViewController {
    @IBOutlet weak var cardView: UIView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        cardEnlargeTransition(cardView: cardView, toVC: segue.destination)
    }
}
