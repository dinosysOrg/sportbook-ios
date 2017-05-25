//
//  BaseViewController.swift
//  SportBook
//
//  Created by DucBM on 5/18/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import UIKit

class BaseViewController : UIViewController {
    
    //Dismiss keybord in View Controller
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
