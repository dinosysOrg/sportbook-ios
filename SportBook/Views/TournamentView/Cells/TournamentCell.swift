//
//  TournamentCell.swift
//  SportBook
//
//  Created by DucBM on 6/7/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import UIKit

class TournamentCell : UITableViewCell {
    
    @IBOutlet weak var lblTournamentName: UILabel!
    
    @IBOutlet weak var lblRegisterTime: UILabel!
    
    @IBOutlet weak var lblTournamentTime: UILabel!
    
    func configure(tournament : TournamentModel) {
        
        lblTournamentName.text = tournament.name
        
        lblTournamentTime.text = tournament.startDate
    }
}
