//
//  SkillCell.swift
//  SportBook
//
//  Created by DucBM on 6/12/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import UIKit

class SkillCell : UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var lblLevel: UILabel!
    
    @IBOutlet weak var tvDescription: UITextView!
    
    func configure(skill : SkillModel) {
        lblLevel.text = skill.name
    }
    
    func configureUI(){
        //Set shadow for cell border here
        self.containerView.layer.borderColor = UIColor.lightGray.cgColor
        self.containerView.layer.borderWidth = 1
    }
}
