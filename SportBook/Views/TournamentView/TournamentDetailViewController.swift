//
//  TournamentDetailViewController.swift
//  SportBook
//
//  Created by DucBM on 6/6/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TournamentDetailViewController : BaseViewController {
    
    var currentTournament : TournamentModel?
    
    fileprivate var viewModel : TournamentDetailViewModel!
    
    fileprivate let disposeBag = DisposeBag()
    
    @IBOutlet weak var coverView: UIView!
    
    @IBOutlet weak var lblTournamentName: UILabel!
    
    @IBOutlet weak var imgCover: UIImageView!
    
    @IBOutlet weak var btnSignUp: UIButton!
    
    override func viewDidLoad() {
        self.configureViewModel()
        self.configureBindings()
        self.viewModel.loadTournamentDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.viewModel?.loadTournamentDetail()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let signUpTournamentViewController = segue.destination as? SignUpTournamentViewController {
            signUpTournamentViewController.currentTournament = viewModel.tournament.value
        }
    }
    
    func configureViewModel() {
        self.viewModel = TournamentDetailViewModel(tournament: self.currentTournament!)
    }
    
    private func configureBindings() {
        self.viewModel.tournament.asDriver().drive(onNext: { [unowned self] tournament in
            self.lblTournamentName.text = tournament?.name
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
}
