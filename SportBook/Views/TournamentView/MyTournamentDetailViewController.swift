//
//  MyTournamentDetailViewController.swift
//  SportBook
//
//  Created by Bui Minh Duc on 6/23/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

fileprivate enum TournamentMenuType : Int {
    case rule = 0
    case venue = 1
    case timeTable = 2
    case opponent = 3
    case result = 4
}

class MyTournamentDetailViewController : BaseViewController {
    
    var currentTournament : TournamentModel?
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let viewModel = TournamentDetailViewModel()
    
    fileprivate let menuCell = "TournamentMenuCell"
    
    fileprivate let menuSection = 1
    
    fileprivate let menuNumber = 5
    
    fileprivate let menuFooterHeight : CGFloat = 0.01
    
    fileprivate let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = currentTournament?.name
        
        self.configureViewModel()
        self.configureTableView()
        self.configureBindings()
        
        self.viewModel.loadTournamentDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func configureViewModel() {
        self.viewModel.tournament.value = self.currentTournament
    }
    
    private func configureBindings() {
        self.viewModel.tournament.asDriver().drive(onNext: { [unowned self] tournament in
            guard let detailTournament = tournament else {
                return
            }
            
            self.currentTournament = detailTournament
        }).disposed(by: disposeBag)
    }
    
    private func configureTableView() {
        self.tableView.reloadData()
    }
    
    fileprivate func getMenuName(menuType: TournamentMenuType) -> String {
        switch menuType {
        case .rule:
            return "rule_regulation".localized
        case .venue:
            return "rank_venue".localized
        case .timeTable:
            return "tournament_time_table".localized
        case .opponent:
            return "opponent_list".localized
        case .result:
            return "tournament_result".localized
        }
    }
}

// MARK: Table View
extension MyTournamentDetailViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return menuSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuNumber
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.menuCell) as! TournamentMenuCell
        
        let menuTitle = self.getMenuName(menuType: TournamentMenuType(rawValue: row)!)
        
        cell.configure(title: menuTitle)
        
        return cell
    }
    
    //Display tournament detail view controller when user select a tournament
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        let menuType = TournamentMenuType(rawValue: row)!
        
        switch menuType {
        case .rule:
            let ruleViewController = UIStoryboard.loadRuleViewController()
            ruleViewController.currentTournament = self.currentTournament
            
            self.navigationController?.pushViewController(ruleViewController, animated: true)
            break
        case .venue:
            let venueViewController = UIStoryboard.loadInputRankVenueViewController()
            venueViewController.currentTournament = self.currentTournament
            
            self.navigationController?.pushViewController(venueViewController, animated: true)
            break
        case .timeTable:
            break
        case .opponent:
            break
        case .result:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let menuCell = cell as! TournamentMenuCell
        menuCell.configureUI()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let menuCellHeight = tableView.frame.size.height / CGFloat(menuNumber)
        
        return menuCellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return menuFooterHeight
    }
}
