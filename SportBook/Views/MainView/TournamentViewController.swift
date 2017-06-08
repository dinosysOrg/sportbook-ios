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

class TournamentViewController : BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let tournamentCell = "TournamentCell"
    
    let myTournamentCell = "MyTournamentCell"
    
    let tournamentViewModel = TournamentViewModel()
    
    let tournamentSection = 1
    
    let tournamentCellHeight : CGFloat = 200
    
    let disposeBag = DisposeBag()
    
    var refreshControl: UIRefreshControl?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.title = "tournament".localized
        self.tabBarItem = UITabBarItem(title: "tournament".localized, image: nil, selectedImage: nil)
        self.tabBarItem.tag = 0
    }
    
    override func viewDidLoad() {
        refresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    func refresh() {
        //Subcribe get tournament
        tournamentViewModel.getTournaments().subscribe( onError: { error in
            //If error, display it
            if let sbError = error as? SportBookError {
                ErrorManager.sharedInstance.showError(viewController: self, error: sbError)
            }
        }, onCompleted: { [weak self] in
            //If complete, reload data for tableview
            self?.tableView.reloadData()
        }).addDisposableTo(disposeBag)
    }
    
     // MARK: - Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return tournamentSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tournamentViewModel.tournaments.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let tournaments = tournamentViewModel.tournaments.value
        
        if row <= tournaments.count - 1 {
            let tournament = tournaments[row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: tournamentCell) as! TournamentCell
            
            cell.configure(tournament: tournament)
            
            return cell
        }
        
        return tableView.dequeueReusableCell(withIdentifier: "cell")!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tournamentCellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}
