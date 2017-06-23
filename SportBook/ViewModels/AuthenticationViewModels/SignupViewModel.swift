//
//  SignupViewModel.swift
//  SportBook
//
//  Created by DucBM on 5/18/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class SignupViewModel {
    
    let emailValid: Driver<Bool>
    
    let passwordValid: Driver<Bool>

    let confirmPasswordValid: Driver<Bool>
    
    let credentialsValid: Driver<Bool>
    
    init(emailText: Driver<String>, passwordText: Driver<String>, confirmPasswordText: Driver<String>) {
        
        emailValid = emailText
            .distinctUntilChanged()
            .throttle(0.3)
            .map(Validation.emailValid).skip(1)
        
        passwordValid = passwordText
            .distinctUntilChanged()
            .throttle(0.3)
            .map { $0.utf8.count > 6 }.skip(1)
        
        confirmPasswordValid = Driver.combineLatest(passwordText, confirmPasswordText) { $0 == $1 }
        
        credentialsValid = Driver.combineLatest(emailValid, passwordValid, confirmPasswordValid) { $0 && $1 && $2}.startWith(false)
    }
    
    func signUp(_ email: String, password: String) -> Observable<AuthenticationStatus> {
        return AuthManager.sharedInstance.signUp(email, password: password)
    }
}
