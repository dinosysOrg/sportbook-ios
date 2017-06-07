//
//  ForgotPasswordViewModel.swift
//  SportBook
//
//  Created by DucBM on 5/18/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class ForgotPasswordViewModel {
    let emailValid: Driver<Bool>
    
    init(emailText: Driver<String>) {
        emailValid = emailText
            .distinctUntilChanged()
            .throttle(0.3)
            .map { Validation.emailValid(email: $0) }.skip(1)
    }
    
    func resetPassword(_ email: String) -> Observable<AuthenticationStatus> {
        return AuthManager.sharedInstance.resetPassword(email)
    }

}
