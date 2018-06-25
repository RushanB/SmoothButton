//
//  ViewController.swift
//  SmoothButtonExample
//
//  Created by RB on 2018-06-24.
//  Copyright © 2018 Smooth Commerce. All rights reserved.
//

import UIKit
import SmoothButton

class ViewController: UIViewController {
    
    @IBAction func action(_ sender: SmoothButton) {
        sender.isLoading = true
        let deadlineTime = DispatchTime.now() + .seconds(3)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            sender.isLoading = false
            // DO SOMETHING
        }
    }    
}

