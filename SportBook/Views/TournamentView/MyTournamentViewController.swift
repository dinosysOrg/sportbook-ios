//
//  MyTournamentViewController.swift
//  SportBook
//
//  Created by DucBM on 6/6/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MyTournamentViewController : BaseViewController {
    
    var myTournaments = [TournamentModel]()
    
    fileprivate let tournamentCell = "TournamentCell"
    
    fileprivate let viewModel = MyTournamentViewModel()
    
    fileprivate let tournamentSection = 1
    
    fileprivate let tournamentCellHeight : CGFloat = 200
    
    fileprivate let tournamentFooterHeight : CGFloat = 0.01
    
    fileprivate let disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        self.title = "my_tournament".localized
        self.configureTableView()
        self.configureViewModel()
        self.configureBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    private func configureViewModel() {
        self.viewModel.myTournaments.value = myTournaments
    }
    
    private func configureBindings() {
    }
    
    private func configureTableView() {
        self.tableView.register(UINib(nibName: self.tournamentCell, bundle: nil), forCellReuseIdentifier: self.tournamentCell)
        self.tableView.reloadData()
    }
}

// MARK: Table View
extension MyTournamentViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tournamentSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myTournaments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        
        if row < myTournaments.count {
            
            let tournament = myTournaments[row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: self.tournamentCell) as! TournamentCell
            
            cell.configureTournament(with: tournament)
            
            return cell
        }
        
        return tableView.dequeueReusableCell(withIdentifier: "cell")!
    }
    
    //Display my tournament detail view controller when user select a tournament
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        if row < myTournaments.count {
            let tournament = myTournaments[row]
            
            if let myTeam = tournament.teams.first {
                if myTeam.status == TeamStatus.paid {
                    //Display my tournament detail view controller
                    let myTournamentDetailViewController = UIStoryboard.loadMyTournamentDetailViewController()
                    
                    myTournamentDetailViewController.currentTournament = tournament
                    
                    self.navigationController?.pushViewController(myTournamentDetailViewController, animated: true)
                    
                } else {
                    ErrorManager.sharedInstance.showMessage(viewController: self, message: "not_pay_tournament_yet".localized)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tournamentCellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tournamentFooterHeight
    }
}

