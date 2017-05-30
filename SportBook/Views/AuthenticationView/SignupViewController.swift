//
//  SignupViewController.swift
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

class SignupViewController : BaseViewController {
    
    let overcastBlueColor = UIColor(red: 0, green: 187/255, blue: 204/255, alpha: 1.0)
    
    @IBOutlet weak var tfEmail: SkyFloatingLabelTextField!
    
    @IBOutlet weak var tfPassword: SkyFloatingLabelTextField!
    
    @IBOutlet weak var tfConfirmPassword: SkyFloatingLabelTextField!
    
    @IBOutlet weak var btnSignup: UIButton!
    
    let disposeBag = DisposeBag()
    
    var signupViewModel : SignupViewModel!
    
    override func viewDidLoad() {
        signupViewModel = SignupViewModel(emailText: tfEmail.rx.text.orEmpty.asDriver(),
                                         passwordText: tfPassword.rx.text.orEmpty.asDriver(),
                                         confirmPasswordText: tfConfirmPassword.rx.text.orEmpty.asDriver())
        
        signupViewModel.credentialsValid
            .drive(onNext: { [unowned self] valid in
                self.btnSignup.isEnabled = valid
            })
            .addDisposableTo(disposeBag)
        
        signupViewModel.emailValid
            .drive(onNext: { [unowned self] valid in
                self.tfEmail.errorMessage = valid ? "" : "Invalid email"
            })
            .addDisposableTo(disposeBag)
        
        signupViewModel.passwordValid
            .drive(onNext: { [unowned self] valid in
                self.tfPassword.errorMessage = valid ? "" : "Must be at least 7 characters"
            })
            .addDisposableTo(disposeBag)
        
        signupViewModel.confirmPasswordValid
            .drive(onNext: { [unowned self] valid in
                self.tfConfirmPassword.errorMessage = valid ? "" : "Confirm password does not match"
            })
            .addDisposableTo(disposeBag)
        
        let signUpTap = btnSignup.rx.tap
        
        
        signUpTap.asObservable().subscribe(onNext: { [unowned self] _ in
            self.dismissKeyboard()
        }).addDisposableTo(disposeBag)
        
        signUpTap.withLatestFrom(signupViewModel.credentialsValid)
            .filter { $0 }
            .flatMapLatest { [unowned self] valid -> Observable<AuthenticationStatus> in
                self.signupViewModel.signUp(self.tfEmail.text!, password: self.tfPassword.text!)
                    .observeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] authStatus in
                switch authStatus {
                case .None:
                    break
                case .Authenticated:
                    self.navigationController?.popViewController(animated: true)
                    break
                case .Error(let error):
                    self.showError(error)
                    break
                }
            })
            .addDisposableTo(disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
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
            title = "Sign up failed"
            message = error.description
            break
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
