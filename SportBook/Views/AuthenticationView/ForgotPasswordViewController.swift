//
//  ForgotPasswordViewController.swift
//  SportBook
//
//  Created by DucBM on 5/18/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import RxKeyboard
import SkyFloatingLabelTextField

class ForgotPasswordViewController : BaseViewController {
    
    let disposeBag = DisposeBag()
    
    var forgotPasswordViewModel : ForgotPasswordViewModel!

    @IBOutlet weak var tfEmail: SkyFloatingLabelTextField!
    
    @IBOutlet weak var btnResetPassword: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        forgotPasswordViewModel = ForgotPasswordViewModel(emailText: tfEmail.rx.text.orEmpty.asDriver())
        
        forgotPasswordViewModel.emailValid
            .drive(onNext: { [unowned self] valid in
                self.tfEmail.errorMessage = valid ? "" : "invalid_email".localized
            })
            .addDisposableTo(disposeBag)
        
        forgotPasswordViewModel.emailValid.startWith(false)
            .drive(onNext: { [unowned self] valid in
                self.btnResetPassword.isEnabled = valid
            })
            .addDisposableTo(disposeBag)
        
        let resetPasswordTap = btnResetPassword.rx.tap
        
        resetPasswordTap.subscribe(onNext: { [unowned self] _ in
            self.dismissKeyboard()
        }).addDisposableTo(disposeBag)
        
        resetPasswordTap
            .withLatestFrom(forgotPasswordViewModel.emailValid)
            .filter { $0 }
            .flatMapLatest { [unowned self] valid -> Observable<AuthenticationStatus> in
                self.forgotPasswordViewModel.resetPassword(self.tfEmail.text!)
                    .observeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
                    .catchError { error -> Observable<AuthenticationStatus> in
                        return Observable.of(AuthenticationStatus.Error(error as! SportBookError))
                }
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] authStatus in
                switch authStatus {
                case .PasswordReset:
                    //Notify user open mail and do reset password then back to sign up page
                    self.navigationController?.popViewController(animated: true)
                    break
                case .Error(let error):
                    self.alertError(text: error.description).subscribe(onCompleted: {})
                        .addDisposableTo(self.disposeBag)
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
