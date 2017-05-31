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
                self.tfEmail.errorMessage = valid ? "" : "invalid_email".localized
            })
            .addDisposableTo(disposeBag)
        
        signupViewModel.passwordValid
            .drive(onNext: { [unowned self] valid in
                self.tfPassword.errorMessage = valid ? "" : "password_minimum_length".localized
            })
            .addDisposableTo(disposeBag)
        
        signupViewModel.confirmPasswordValid
            .drive(onNext: { [unowned self] valid in
                self.tfConfirmPassword.errorMessage = valid ? "" : "password_not_match".localized
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
                case .SignedUp:
                    self.navigationController?.popViewController(animated: true)
                    break
                case .Error(let error):
                    self.showError(error)
                    break
                default:
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
}
