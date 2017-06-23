//
//  TournamentCell.swift
//  SportBook
//
//  Created by Bui Minh Duc on 6/22/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import UIKit

class TournamentCell: UITableViewCell {

    @IBOutlet weak var lblTournamentName: UILabel!
    
    @IBOutlet weak var lblStartDate: UILabel!
    
    @IBOutlet weak var lblEndDate: UILabel!
    
    @IBOutlet weak var imgCover: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureTournament(with tournament: TournamentModel) {
        self.lblTournamentName.text = tournament.name
        self.lblStartDate.text = tournament.startDate
        self.lblEndDate.text = tournament.endDate
    }
}
