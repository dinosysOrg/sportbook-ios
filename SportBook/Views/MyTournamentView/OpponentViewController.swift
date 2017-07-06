//
//  OpponentViewController.swift
//  SportBook
//
//  Created by Bui Minh Duc on 6/26/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class OpponentViewController: BaseViewController {
    
    fileprivate let disposeBag = DisposeBag()
    
    @IBOutlet weak var stageContainerView: UIView!
    
    @IBOutlet weak var lblStageName: UILabel!
    
    @IBOutlet weak var lblDeadline: UILabel!
    
    @IBOutlet weak var lblGroupName: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentTournament : TournamentModel?
    
    let viewModel = OpponentViewModel()
    
    let opponentCell = "OpponentCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "opponent_list".localized
        self.configureViewModel()
        self.configureBinding()
        self.loadOpponents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func loadOpponents(){
        self.viewModel.loadOpponentList().subscribe(onCompleted: { _ in }).addDisposableTo(self.disposeBag)
    }
    
    private func configureViewModel(){
        self.viewModel.tournament.value = self.currentTournament
        self.viewModel.myGroups.asObservable().subscribe(onNext: { _ in
            
            self.tableView.reloadData()
            
            guard let groupName = self.viewModel.myGroups.value.first?.name else {
                return
            }
            
            self.lblGroupName.text = groupName
        }).addDisposableTo(self.disposeBag)
    }
    
    private func configureBinding(){
        self.viewModel.hasFailed.asObservable().skip(1).subscribe(onNext: { [unowned self] error in
            if case SportBookError.unauthenticated = error {
                AuthManager.sharedInstance.clearSession()
                
                //Present login view controller
                let loginViewController = UIStoryboard.loadLoginViewController()
                self.tabBarController?.present(loginViewController, animated: true, completion: { })
            } else {
                self.alertError(text: error.description).subscribe(onCompleted: {})
                    .addDisposableTo(self.disposeBag)
            }
        }).disposed(by: disposeBag)
    }
}

extension OpponentViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.myGroups.value.first?.opponents?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        guard let opponent = self.viewModel.myGroups.value.first?.opponents?[row] else {
            return tableView.dequeueReusableCell(withIdentifier: "cell")!
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.opponentCell) as! OpponentCell
        
        cell.configure(opponent: opponent)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let opponentCell = cell as! OpponentCell
        
        opponentCell.configureUI()
    }
}
