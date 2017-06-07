//
//  LoginViewModel.swift
//  SportBook
//
//  Created by DucBM on 5/18/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftyJSON
import Moya
import FacebookCore
import FacebookLogin

class LoginViewModel {
    
    let disposeBag = DisposeBag()
    
    let emailValid: Driver<Bool>
    
    let passwordValid: Driver<Bool>
    
    let credentialsValid: Driver<Bool>
    
    init(emailText: Driver<String>, passwordText: Driver<String>) {
        
        emailValid = emailText
            .distinctUntilChanged()
            .throttle(0.3)
            .map { Validation.emailValid(email: $0) }.skip(1)
        
        passwordValid = passwordText
            .distinctUntilChanged()
            .throttle(0.3)
            .map { $0.utf8.count > 6 }.skip(1)
        
        credentialsValid = Driver.combineLatest(emailValid, passwordValid) { $0 && $1 }.startWith(false)
    }
    
    func signInWithEmail(_ email: String, password: String) -> Observable<AuthenticationStatus> {
        return AuthManager.sharedInstance.signIn(email, password: password)
    }
    
    func signInWithFacebook(viewcontroller : UIViewController) -> Observable<AuthenticationStatus> {
        
        let loginManager = LoginManager()
        
        //Make sure Facebook logged out
        loginManager.logOut()
        
        //Create observable to do login facebook and return result
        return Observable<AuthenticationStatus>.create { observer in
            
            //Init permission
            let permission = [ReadPermission.publicProfile, ReadPermission.userFriends]
            
            //Login with permision, view controller and completion closure
            loginManager.logIn(permission, viewController: viewcontroller, completion: { result in
                
                switch result {
                //If success return notify and acess token
                case .success(_, _, let accessToken):
                    AuthManager.sharedInstance.signIn(accessToken.authenticationToken)
                        .catchError { error -> Observable<AuthenticationStatus> in
                            return Observable.of(AuthenticationStatus.Error(.ConnectionFailure))
                        }
                        .subscribe(onNext: { authStatus in
                            observer.onNext(authStatus)
                        }).addDisposableTo(self.disposeBag)
                    break
                //If user cancelled notify false and message
                case .cancelled:
                    //Notify cancelled error
                    observer.onNext(AuthenticationStatus.Error(SportBookError.UserCancelled))
                    break
                //If failed to login notify false and error message
                case .failed(let error):
                    //Notify request failed error
                    observer.onNext(AuthenticationStatus.Error(SportBookError.Custom(error.localizedDescription)))
                    break
                }
            })
            
            return Disposables.create()
        }
    }
}
