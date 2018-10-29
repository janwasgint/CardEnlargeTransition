//
//  PresentedViewController.swift
//  CardEnlargingTransition
//
//  Created by Jan Wasgint on 20.10.18.
//  Copyright © 2018 Jan Wasgint. All rights reserved.
//

import UIKit

class PresentedViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    @IBAction func buttonPressed() {
        navigationController?.popViewController(animated: true)
//        dismiss(animated: true, completion: nil)
    }
}
