//
//  ProfileViewController.swift
//  SportBook
//
//  Created by DucBM on 5/24/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import UIKit

class ProfileViewController : BaseViewController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.title = "profile".localized
        self.tabBarItem = UITabBarItem(title: "profile".localized, image: nil, selectedImage: nil)
        self.tabBarItem.tag = 0
    }
    
    override func viewDidLoad() {
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
}
