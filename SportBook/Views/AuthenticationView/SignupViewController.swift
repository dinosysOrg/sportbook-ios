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

class SignupViewController : BaseViewController {
    
    @IBOutlet weak var tfEmail: UITextField!
    
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBOutlet weak var tfConfirmPassword: UITextField!
    
    @IBOutlet weak var btnSignup: UIButton!
    
    let disposeBag = DisposeBag()
    
    var signupViewModel : SignupViewModel = SignupViewModel()
    
    override func viewDidLoad() {
        //Subscribe text field text changed
        tfEmail.rx.text.observeOn(MainScheduler.instance).subscribe(onNext: { text in
            self.signupViewModel.email = text
        }).addDisposableTo(disposeBag)
        
        tfPassword.rx.text.observeOn(MainScheduler.instance).subscribe(onNext: { text in
            self.signupViewModel.password = text
        }).addDisposableTo(disposeBag)
        
        tfConfirmPassword.rx.text.observeOn(MainScheduler.instance).subscribe(onNext: { text in
            self.signupViewModel.confirmPassword = text
        }).addDisposableTo(disposeBag)
        
        //Create view tap observable
        let viewTap = view.rx.tapGesture().when(.recognized)
        
        //Create sign up button tap observable
        let signupTap = btnSignup.rx.tapGesture().when(.recognized)
        
        //Merge view tap and sign up button tap
        Observable.from([viewTap, signupTap]).asObservable().subscribe(onNext: {_ in
            self.dismissKeyboard()
        }).addDisposableTo(disposeBag)
        
        signupTap.flatMap {_ in
            return self.signupViewModel.signup()
            }.observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] in
                print("Sign Up Success!!!")
                let mainView = UIStoryboard.loadMainViewController()
                self?.dismiss(animated: false) {}
                self?.navigationController?.present(mainView, animated: true, completion: {})
                }).addDisposableTo(self.disposeBag)
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
