//
//  TournamentMenuCell.swift
//  SportBook
//
//  Created by Bui Minh Duc on 6/23/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import UIKit

class TournamentMenuCell : UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    func configure(title : String) {
        lblTitle.text = title
    }
    
    func configureUI(){
        
        //Set cell border
        self.containerView.layer.borderColor = UIColor.lightGray.cgColor
        self.containerView.layer.borderWidth = 1
    }
}
