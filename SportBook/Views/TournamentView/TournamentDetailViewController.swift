//
//  TournamentDetailViewController.swift
//  SportBook
//
//  Created by DucBM on 6/6/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import UIKit
import PageMenu
import RxSwift
import RxCocoa

class TournamentDetailViewController : BaseViewController {
    
    var currentTournament : TournamentModel?
    
    var pageMenu : CAPSPageMenu?
    
    fileprivate let viewModel = TournamentDetailViewModel()
    
    fileprivate let disposeBag = DisposeBag()
    
    @IBOutlet weak var coverView: UIView!
    
    @IBOutlet weak var imgCover: UIImageView!
    
    @IBOutlet weak var btnSignUp: UIButton!
    
    @IBOutlet weak var infoContainerView: UIView!
    
    override func viewDidLoad() {
        self.title = currentTournament?.name
        self.configureViewModel()
        self.configureBindings()
        self.configureMenu()
        self.viewModel.loadTournamentDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.viewModel.loadTournamentDetail()
    }
    
    func configureViewModel() {
        self.viewModel.tournament.value = currentTournament
    }
    
    private func configureBindings() {
        let signUpTap = self.btnSignUp.rx.tap
        
        //When use tap sign up
        signUpTap.asObservable().subscribe(onNext: { [unowned self] _ in
            let user = UserManager.sharedInstance.user!
            
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
        guard let myTeam = tournament.myTeam else {
            self.btnSignUp.isEnabled = true
            
            return
        }
        
        if myTeam.status == TeamStatus.registered {
             self.updateSignUpButton(true)
        } else {
            //Implement later
        }
        
        self.configureMenu()
    }
    
    func updateSignUpButton(_ signedUp : Bool) {
        if signedUp {
            self.btnSignUp.isEnabled = false
            self.btnSignUp.setTitle("payment_pending".localized.uppercased(), for: .normal)
        } else {
            self.btnSignUp.isEnabled = true
        }
    }
    
    
    func configureMenu() {
        for subView in self.infoContainerView.subviews {
            subView.removeFromSuperview()
        }
        
        // Array to keep track of controllers in page menu
        var controllerArray : [UIViewController] = []
        
        // Create variables for all view controllers you want to put in the
        // page menu, initialize them, and add each to the controller array.
        // (Can be any UIViewController subclass)
        // Make sure the title property of all view controllers is set
        // Example:
        let ruleViewController : WebViewController = WebViewController(nibName: "WebViewController", bundle: nil)
        ruleViewController.title = "rule_tab".localized
        ruleViewController.htmlString = currentTournament?.competitionMode
        
        let feeViewController : WebViewController = WebViewController(nibName: "WebViewController", bundle: nil)
        feeViewController.title = "fee_tab".localized
        feeViewController.htmlString = currentTournament?.competitionFee
        
        let scheduleViewController : WebViewController = WebViewController(nibName: "WebViewController", bundle: nil)
        scheduleViewController.title = "schedule_tab".localized
        scheduleViewController.htmlString = currentTournament?.competitionSchedule
        
        controllerArray.append(ruleViewController)
        controllerArray.append(feeViewController)
        controllerArray.append(scheduleViewController)
        
        // Customize page menu to your liking (optional) or use default settings by sending nil for 'options' in the init
        // Example:
        let parameters: [CAPSPageMenuOption] = [
            .scrollMenuBackgroundColor(UIColor.white),
            .selectedMenuItemLabelColor(UIColor.black),
            .unselectedMenuItemLabelColor(UIColor.gray),
            .menuItemSeparatorWidth(0),
            .useMenuLikeSegmentedControl(false)
        ]
        
        // Initialize page menu with controller array, frame, and optional parameters
        let pageMenuFrame = CGRect(x: 0, y: 0, width: self.infoContainerView.frame.width, height: self.infoContainerView.frame.height)
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: pageMenuFrame, pageMenuOptions: parameters)
        
        // Lastly add page menu as subview of base view controller view
        // or use pageMenu controller in you view hierachy as desired
        self.infoContainerView.addSubview(pageMenu!.view)
    }
}
