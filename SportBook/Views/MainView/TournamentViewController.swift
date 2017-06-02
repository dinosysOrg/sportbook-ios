//
//  TournamentViewController.swift
//  SportBook
//
//  Created by DucBM on 6/1/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import UIKit

class TournamentViewController : BaseViewController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.title = "tournament".localized
        self.tabBarItem = UITabBarItem(title: "tournament".localized, image: nil, selectedImage: nil)
        self.tabBarItem.tag = 0
    }
    
    override func viewDidLoad() {
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
}
