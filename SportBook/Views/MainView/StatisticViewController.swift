//
//  Statistic.swift
//  SportBook
//
//  Created by DucBM on 6/1/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import UIKit

class StatisticViewController : BaseViewController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.title = "statistic".localized
        self.tabBarItem = UITabBarItem(title: "statistic".localized, image: nil, selectedImage: nil)
        self.tabBarItem.tag = 0
    }
    
    override func viewDidLoad() {
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
}
