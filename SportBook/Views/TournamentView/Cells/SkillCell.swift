//
//  SkillCell.swift
//  SportBook
//
//  Created by DucBM on 6/12/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import UIKit

class SkillCell : UITableViewCell {
    
    let selectedIcon = UIImage(named: "rad_check")
    let unselectedIcon = UIImage(named: "rad_uncheck")
    
    @IBOutlet weak var imgSelection: UIImageView!
    
    @IBOutlet weak var lblLevel: UILabel!
    
    func configure(skill : SkillModel) {
        lblLevel.text = skill.name
    }
    
    func select(){
        self.imgSelection.image = selectedIcon
    }
    
    func deselect(){
        self.imgSelection.image = unselectedIcon
    }
}
