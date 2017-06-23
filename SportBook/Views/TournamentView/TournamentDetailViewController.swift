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
    
    @IBOutlet weak var imgCover: UIImageView!
    
    @IBOutlet weak var btnSignUp: UIButton!
    
    override func viewDidLoad() {
        self.title = currentTournament?.name
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
    
    func configureViewModel() {
        self.viewModel = TournamentDetailViewModel(tournament: self.currentTournament!)
    }
    
    private func configureBindings() {
        let signUpTap = self.btnSignUp.rx.tap
        
        //When use tap sign up
        signUpTap.asObservable().subscribe(onNext: { [unowned self] _ in
            let user = UserManager.sharedInstance.user!
            
            let tournament = self.viewModel.tournament.value!
            
            //If there's no team, it means that user have not sign up this tournament yet
            if tournament.teams.count == 0 {
                //Check his/her profile if they had signed up any tournament before
                if user.hasTournamentProfile {
                    //If had, do fast sign up with their info
                    self.viewModel.fastSignUpTournament().subscribe(onNext: { success in
                        self.updateSignUpButton(success)
                    }).addDisposableTo(self.disposeBag)
                } else {
                    //Else move them to sign up view
                    let signUpTournamentViewController = UIStoryboard.loadSignUpTournamentViewController()
                    
                    signUpTournamentViewController.currentTournament = self.viewModel.tournament.value
                    signUpTournamentViewController.signUpSuccess.asDriver().drive(onNext: { [unowned self] success in
                        self.updateSignUpButton(success)
                    }).addDisposableTo(self.disposeBag)
                    
                    self.navigationController?.pushViewController(signUpTournamentViewController, animated: true)
                }
            } else {
                
            }
        }).addDisposableTo(disposeBag)
        
        self.viewModel.tournament.asDriver().drive(onNext: { [unowned self] tournament in
            guard let detailTournament = tournament else {
                return
            }
            self.updateUI(tournament: detailTournament)
        }).disposed(by: disposeBag)
        
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
    
    func updateUI(tournament : TournamentModel) {
        if tournament.teams.count > 0 {
            let myTeam = tournament.teams.first!
            
            if myTeam.status == TeamStatus.registered {
                self.updateSignUpButton(true)
            } else {
                //Implement later
            }
        } else {
            self.btnSignUp.isEnabled = true
        }
    }
    
    func updateSignUpButton(_ signedUp : Bool) {
        if signedUp {
            self.btnSignUp.isEnabled = false
            self.btnSignUp.setTitle("payment_pending".localized.uppercased(), for: .normal)
        } else {
            self.btnSignUp.isEnabled = true
        }
    }
}
