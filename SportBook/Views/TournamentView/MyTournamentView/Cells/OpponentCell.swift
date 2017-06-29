//
//  OpponentCell.swift
//  SportBook
//
//  Created by Bui Minh Duc on 6/29/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import UIKit

class OpponentCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var imgAvatar: UIImageView!
    
    @IBOutlet weak var lblOpponentName: UILabel!
    
    @IBOutlet weak var lblStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(team : TeamModel) {
        self.lblOpponentName.text = team.name
        self.lblStatus.text = "Invited"
    }
    
    func configureUI(){
        self.containerView.layer.addBorder(edge: .bottom, color: .lightGray, thickness: 1)
    }
}

