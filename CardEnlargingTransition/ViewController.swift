//
//  ViewController.swift
//  CardEnlargingTransition
//
//  Created by Jan Wasgint on 19.10.18.
//  Copyright © 2018 Jan Wasgint. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var cardView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationController?.navigationBar.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        CardAnimationViewController.setup(cardView: cardView, fromVC: self, navigationController: navigationController!)
//        CardAnimationViewController.setup(cardView: cardView, segue: segue)
    }
}
