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
    
    let credentialsValid: Driver<Bool>
    
    init(emailText: Driver<String>, passwordText: Driver<String>, confirmPasswordText: Driver<String>) {
        
        let usernameValid = emailText
            .distinctUntilChanged()
            .throttle(0.3)
            .map { Validation.emailValid(email: $0) }
        
        let passwordValid = passwordText
            .distinctUntilChanged()
            .throttle(0.3)
            .map { $0.utf8.count > 6 }
        
        let repeatPasswordValid = Driver.combineLatest(passwordText, confirmPasswordText) { $0 == $1 }
        
        credentialsValid = Driver.combineLatest(usernameValid, passwordValid, repeatPasswordValid) { $0 && $1 && $2}
    }
    
    func signUp(_ email: String, password: String) -> Observable<AuthenticationStatus> {
        return AuthManager.sharedInstance.signUp(email, password: password)
    }
}
