//
//  ViewController.swift
//  SportBook
//
//  Created by DucBM on 5/17/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //If unauthenticated, present login view
        if !AuthManager.sharedInstance.IsAuthenticated {
            let loginViewController = UIStoryboard.loadLoginViewController()
            self.present(loginViewController, animated: false, completion: {})
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

