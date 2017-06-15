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
    
    fileprivate let tournamentCell = "TournamentCell"
    
    fileprivate let myTournamentCell = "MyTournamentCell"
    
    fileprivate let viewModel = TournamentViewModel()
    
    fileprivate let tournamentSection = 1
    
    fileprivate let tournamentCellHeight : CGFloat = 200
    
    fileprivate let tournamentFooterHeight : CGFloat = 0.01
    
    fileprivate let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.title = "tournament".localized
        self.tabBarItem = UITabBarItem(title: "tournament".localized, image: nil, selectedImage: nil)
        self.tabBarItem.tag = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        refresh()
    }
    
    private func configureBindings() {
        self.viewModel.tournaments.asDriver().skip(1).drive(onNext: { [unowned self] _ in
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        self.viewModel.hasFailed.asObservable().skip(1).subscribe(onNext: { [unowned self] error in
            if case SportBookError.Unauthenticated = error {
                AuthManager.sharedInstance.clearSession()
                
                //Present login view controller
                let loginViewController = UIStoryboard.loadLoginViewController()
                self.tabBarController?.present(loginViewController, animated: true, completion: { })
            } else {
                ErrorManager.sharedInstance.showError(viewController: self, error: error)
            }
        }).disposed(by: disposeBag)
    }
    
    func refresh() {
        viewModel.loadTournaments()
    }
}

// MARK: Table View
extension TournamentViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tournamentSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tournaments.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        let tournaments = viewModel.tournaments.value
        
        if row <= tournaments.count - 1 {
            let tournament = tournaments[row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: tournamentCell) as! TournamentCell
            
            cell.configure(tournament: tournament)
            
            return cell
        }
        
        return tableView.dequeueReusableCell(withIdentifier: "cell")!
    }
    
    //Display tournament detail view controller when use select a tournament
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let tournaments = viewModel.tournaments.value
        
        if row <= tournaments.count - 1 {
            let tournament = tournaments[row]
            
            let tournamentDetailViewController = UIStoryboard.loadTournamentDetailViewController()
            
            tournamentDetailViewController.currentTournament = tournament
            
            self.navigationController?.pushViewController(tournamentDetailViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tournamentCellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tournamentFooterHeight
    }
}
