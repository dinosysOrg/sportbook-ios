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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let backIconImage = UIImage(named: "ic_back")
        self.navigationController?.navigationBar.backIndicatorImage = backIconImage
        self.navigationController?.navigationBar.tintColor = UIColor.darkGray
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backIconImage
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    }

}


