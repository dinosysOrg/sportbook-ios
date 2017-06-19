//
//  TournamentViewController.swift
//  SportBook
//
//  Created by DucBM on 6/1/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TournamentViewController : BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let tournamentCell = "TournamentCell"
    
    let myTournamentCell = "MyTournamentCell"
    
    let tournamentViewModel = TournamentViewModel()
    
    let tournamentSection = 1
    
    let tournamentCellHeight : CGFloat = 200
    
    let tournamentFooterHeight : CGFloat = 0.01
    
    let disposeBag = DisposeBag()
    
    var refreshControl: UIRefreshControl?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.title = "tournament".localized
        self.tabBarItem = UITabBarItem(title: "tournament".localized, image: nil, selectedImage: nil)
        self.tabBarItem.tag = 0
    }
    
    override func viewDidLoad() {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        refresh()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    func refresh() {
        //Subcribe get tournament
        tournamentViewModel.getTournaments().subscribe( onError: { error in
            //If error, display it
            if let sbError = error as? SportBookError {
                //If token or session expired, do sign out
                if case SportBookError.Unauthenticated = sbError {
                    AuthManager.sharedInstance.clearSession()
                    
                    //Present login view controller
                    let loginViewController = UIStoryboard.loadLoginViewController()
                    self.tabBarController?.present(loginViewController, animated: true, completion: { })
                } else {
                    ErrorManager.sharedInstance.showError(viewController: self, error: sbError)
                }            }
        }, onCompleted: { [weak self] in
            //If complete, reload data for tableview
            self?.tableView.reloadData()
        }).addDisposableTo(disposeBag)
    }
}

// MARK: Table View
extension TournamentViewController : UITableViewDelegate, UITableViewDataSource{
 
    func numberOfSections(in tableView: UITableView) -> Int {
        return tournamentSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        //return tournamentViewModel.tournaments.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tournamentCell) as! TournamentCell
        
        cell.setSampleData()
        
        return cell

//        let row = indexPath.row
//        let tournaments = tournamentViewModel.tournaments.value
//        
//        if row <= tournaments.count - 1 {
//            let tournament = tournaments[row]
//            
//            let cell = tableView.dequeueReusableCell(withIdentifier: tournamentCell) as! TournamentCell
//            
//            cell.configure(tournament: tournament)
//            
//            return cell
//        }
//        
//        return tableView.dequeueReusableCell(withIdentifier: "cell")!
    }
    
    //Display tournament detail view controller when use select a tournament
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let row = indexPath.row
//        let tournaments = tournamentViewModel.tournaments.value
//        
//        if row <= tournaments.count - 1 {
//            let tournament = tournaments[row]
//            
            let tournamentDetailViewController = UIStoryboard.loadTournamentDetailViewController()
//
//            tournamentDetailViewController.tournamentDetailViewModel = TournamentDetailViewModel(tournament: tournament)
//            
            self.navigationController?.pushViewController(tournamentDetailViewController, animated: true)
//        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tournamentCellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tournamentFooterHeight
    }
}
