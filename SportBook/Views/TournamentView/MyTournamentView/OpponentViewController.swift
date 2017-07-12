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
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentTournament : TournamentModel?
    
    let viewModel = OpponentViewModel()
    
    let opponentCell = "OpponentCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "opponent_list".localized
        self.configureViewModel()
        self.loadOpponents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func loadOpponents(){
        self.viewModel.loadOpponentList().subscribe(onCompleted: { _ in
            self.tableView.reloadData()
        }).addDisposableTo(self.disposeBag)
    }
    
    func configureViewModel(){
        self.viewModel.tournament.value = self.currentTournament
    }
}

extension OpponentViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.opponentCell) as! OpponentCell
        
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
