//
//  ResultCell.swift
//  SportBook
//
//  Created by Bui Minh Duc on 6/30/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import UIKit

class ResultCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var imgTeamAvatar: UIImageView!
    
    @IBOutlet weak var lblTeamName: UILabel!
    
    @IBOutlet weak var lblMatchesStatus: UILabel!
    
    @IBOutlet weak var lblPoint: UILabel!    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure() {
    }
    
    func configureUI(){
    }
}
