//
//  SignupViewModel.swift
//  SportBook
//
//  Created by DucBM on 5/18/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import Foundation
import RxSwift

class SignupViewModel : AuthenticationDelegate {
    
    let disposeBag = DisposeBag()
    
    var email : String! = ""
    
    var password : String! = ""
    
    var confirmPassword : String! = ""
    
    func signup() -> Observable<Void> {
        return Observable<Void>.create { observer in
            //Valid data here
            
            AuthenticationProvider.request(.signUp(self.email, self.password))
                .flatMap { response in
                    return self.handleResponse(response)
                }.subscribe(onError: { error in
                    //observer.onError(error)
                }, onCompleted: { _ in
                    observer.onNext()
                }).addDisposableTo(self.disposeBag)
            
            return Disposables.create()
        }
    }
}
