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

class LoginViewController : BaseViewController {
    
    let disposeBag = DisposeBag()
    
    var loginViewModel : LoginViewModel!
    
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var btnSignup: UIButton!
    
    @IBOutlet weak var btnLoginFacebook: UIButton!
    
    @IBOutlet weak var tfEmail: UITextField!
    
    @IBOutlet weak var tfPassword: UITextField!
    
    override func viewDidLoad() {
        
        loginViewModel = LoginViewModel(emailText: tfEmail.rx.text.orEmpty.asDriver(),
                                             passwordText: tfPassword.rx.text.orEmpty.asDriver())
        
        loginViewModel.credentialsValid
            .drive(onNext: { [unowned self] valid in
                self.btnLogin.isEnabled = valid
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
                self.loginViewModel.signInWithEmail(self.tfEmail.text!, password: self.tfPassword.text!)
                    .observeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
            }
            .observeOn(MainScheduler.instance)
            
        let signInWithFacebook = facebookTap
            .flatMapLatest { [unowned self] _ -> Observable<AuthenticationStatus> in
                self.loginViewModel.signInWithFacebook(viewcontroller: self)
                    .observeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
            }
            .observeOn(MainScheduler.instance)
            
        Observable.from([signInWithEmail, signInWithFacebook])
            .merge().subscribe(onNext: { [unowned self] authStatus in
                switch authStatus {
                case .None:
                    break
                case .Authenticated:
                    let mainView = UIStoryboard.loadMainViewController()
                    self.dismiss(animated: false) {}
                    self.navigationController?.present(mainView, animated: true, completion: {})
                    break
                case .Error(let error):
                    self.showError(error)
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
    
    fileprivate func showError(_ error: AuthenticationError) {
        var title: String = ""
        var message: String = ""
        
        switch error {
        case .Unknown:
            title = "An error occuried"
            message = "Unknown error"
            break
        case .UserCancelled:
            return
        case .Server, .BadReponse:
            title = "An error occuried"
            message = "Server error"
            break
        case .BadCredentials:
            title = "Bad credentials"
            message = "This user don't exist"
            break
        case .Custom(let error):
            title = "Sign in failed"
            message = error.description
            break
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
