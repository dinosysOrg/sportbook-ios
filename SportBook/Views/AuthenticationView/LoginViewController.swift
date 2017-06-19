//
//  LoginViewController.swift
//  SportBook
//
//  Created by DucBM on 5/18/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxGesture
import RxKeyboard
import SkyFloatingLabelTextField

class LoginViewController : BaseViewController {
    
    let disposeBag = DisposeBag()
    
    var loginViewModel : LoginViewModel!
    
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var btnSignup: UIButton!
    
    @IBOutlet weak var btnLoginFacebook: UIButton!
    
    @IBOutlet weak var btnForgotPassword: UIButton!
    
    @IBOutlet weak var tfEmail: SkyFloatingLabelTextField!
    
    @IBOutlet weak var tfPassword: SkyFloatingLabelTextField!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        loginViewModel = LoginViewModel(emailText: tfEmail.rx.text.orEmpty.asDriver(),
                                        passwordText: tfPassword.rx.text.orEmpty.asDriver())
        
        loginViewModel.credentialsValid
            .drive(onNext: { [unowned self] valid in
                self.btnLogin.isEnabled = valid
            })
            .addDisposableTo(disposeBag)
        
        loginViewModel.emailValid
            .drive(onNext: { [unowned self] valid in
                self.tfEmail.errorMessage = valid ? "" : "invalid_email".localized
            })
            .addDisposableTo(disposeBag)
        
        loginViewModel.passwordValid
            .drive(onNext: { [unowned self] valid in
                self.tfPassword.errorMessage = valid ? "" : "password_minimum_length".localized
            })
            .addDisposableTo(disposeBag)
        
        
        let signInTap = btnLogin.rx.tap
        
        let facebookTap = btnLoginFacebook.rx.tap
        
        Observable.from([signInTap, facebookTap]).asObservable().subscribe(onNext: { [unowned self] _ in
            self.dismissKeyboard()
        }).addDisposableTo(disposeBag)
        
        let signInWithEmail = signInTap
            .withLatestFrom(loginViewModel.credentialsValid)
            .filter { $0 }
            .flatMapLatest { [unowned self] valid -> Observable<AuthenticationStatus> in
                return self.loginViewModel.signInWithEmail(self.tfEmail.text!, password: self.tfPassword.text!)
                    .observeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
                    .catchError { error -> Observable<AuthenticationStatus> in
                        return Observable.of(AuthenticationStatus.Error(error as! SportBookError))
            }
            .observeOn(MainScheduler.instance)
        }
        
        let signInWithFacebook = facebookTap
            .flatMapLatest { [unowned self] _ -> Observable<AuthenticationStatus> in
                return self.loginViewModel.signInWithFacebook(viewcontroller: self)
                    .observeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
            }
            .observeOn(MainScheduler.instance)
       
        
        Observable.from([signInWithEmail, signInWithFacebook])
            .merge().subscribe(onNext: { [unowned self] authStatus in
                switch authStatus {
                case .Authenticated:
                    //Login success, dismiss login view controller and reload data in main view
                    self.dismiss(animated: true) {}
                    break
                case .Error(let error):
                    ErrorManager.sharedInstance.showError(viewController: self, error: error)
                    break
                default:
                    break
                }
            })
            .addDisposableTo(disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismissKeyboard()
    }
}
