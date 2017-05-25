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
    
    var loginViewModel = LoginViewModel()
    
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var btnSignup: UIButton!
    
    @IBOutlet weak var btnLoginFacebook: UIButton!
    
    @IBOutlet weak var tfEmail: UITextField!
    
    @IBOutlet weak var tfPassword: UITextField!
    
    override func viewDidLoad() {
        
        //Subscribe text field text changed
        tfEmail.rx.text.observeOn(MainScheduler.instance).subscribe(onNext: { text in
            self.loginViewModel.email = text
        }).addDisposableTo(disposeBag)
        
        tfPassword.rx.text.observeOn(MainScheduler.instance).subscribe(onNext: { text in
            self.loginViewModel.password = text
        }).addDisposableTo(disposeBag)
        
        let signinEmailTap = btnLogin.rx.tapGesture()
            .when(.recognized)
        
        let signinFacebookTap = btnLoginFacebook.rx.tapGesture()
            .when(.recognized)
        
        let signinEmail = signinEmailTap.flatMap {_ in
            return self.loginViewModel.loginWithEmail()
        }
        
        let signinFacebook = signinFacebookTap.flatMap {_ in
            return self.loginViewModel.loginFacebook(viewcontroller: self)
        }
        
        Observable.from([signinEmailTap, signinFacebookTap]).merge().subscribe(onNext: {_ in
            self.dismissKeyboard()
        }).addDisposableTo(disposeBag)
        
        Observable.from([signinEmail, signinFacebook]).merge().observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] in
            print("Sign In Success!!!")
            let mainView = UIStoryboard.loadMainViewController()
            self?.dismiss(animated: false) {}
            self?.navigationController?.present(mainView, animated: true, completion: {})
            }).addDisposableTo(self.disposeBag)
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
