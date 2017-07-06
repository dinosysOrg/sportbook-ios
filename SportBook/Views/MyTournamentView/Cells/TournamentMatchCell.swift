//
//  TournamentMatchCell.swift
//  SportBook
//
//  Created by Bui Minh Duc on 6/29/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import UIKit

class TournamentMatchCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var lblWeekDay: UILabel!
    
    @IBOutlet weak var lblOpponent: UILabel!
    
    @IBOutlet weak var lblVenue: UILabel!
    
    @IBOutlet weak var lblTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure() {
        self.lblWeekDay.text = "sunday".localized
        self.lblOpponent.text = "A1 Match with Mike Tyson"
        self.lblVenue.text = "@ Las Vegas Stadium"
        self.lblTime.text = "5:00 PM - 20:00 PM"
    }
    
    func configureUI(){
    }
}
