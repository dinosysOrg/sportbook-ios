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
        super.viewWillAppear(animated)
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
            
//            self.viewModel.loadMyTournamentDetail(tournamentId: tournament.id).subscribe(onNext: { tournament in
//                guard let myTeam = tournament.myTeam else {
//                    return
//                }
//                
//                if myTeam.status == TeamStatus.paid {
//                    //Display my tournament detail view controller
                    let myTournamentDetailViewController = UIStoryboard.loadMyTournamentDetailViewController()
                    
                    myTournamentDetailViewController.currentTournament = tournament
                    
                    self.navigationController?.pushViewController(myTournamentDetailViewController, animated: true)
//
//                } else {
//                    self.alert(text: "not_pay_tournament_yet".localized).subscribe(onCompleted: {
//                        //Display tournament detail view controller
//                        let tournamentDetailViewController = UIStoryboard.loadTournamentDetailViewController()
//                        
//                        tournamentDetailViewController.currentTournament = tournament
//                        
//                        self.navigationController?.pushViewController(tournamentDetailViewController, animated: true)
//                    }).addDisposableTo(self.disposeBag)
//                }
//            }).addDisposableTo(self.disposeBag)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tournamentCellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tournamentFooterHeight
    }
}

