//
//  TournamentDetailViewController.swift
//  SportBook
//
//  Created by DucBM on 6/6/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import UIKit

class TournamentDetailViewController : BaseViewController {
    
    var tournamentDetailViewModel : TournamentDetailViewModel!

    @IBOutlet weak var coverView: UIView!
    
    @IBOutlet weak var lblTournamentName: UILabel!
    
    @IBOutlet weak var imgCover: UIImageView!
    
    @IBOutlet weak var btnSignUp: UIButton!
    
    override func viewDidLoad() {
        //Set basic info and load tournament detail
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
}
