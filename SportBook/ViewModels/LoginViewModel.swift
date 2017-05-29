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
    
    let credentialsValid: Driver<Bool>
    
    init(emailText: Driver<String>, passwordText: Driver<String>) {
        
        let usernameValid = emailText
            .distinctUntilChanged()
            .throttle(0.3)
            .map { Validation.emailValid(email: $0) }
        
        let passwordValid = passwordText
            .distinctUntilChanged()
            .throttle(0.3)
            .map { $0.utf8.count > 6 }
        
        credentialsValid = Driver.combineLatest(usernameValid, passwordValid) { $0 && $1 }
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
                    AuthManager.sharedInstance.signIn(accessToken.authenticationToken).subscribe(onNext: { authStatus in
                        observer.onNext(authStatus)
                    }).addDisposableTo(self.disposeBag)
                    break
                //If user cancelled notify false and message
                case .cancelled:
                    //Notify cancelled error
                    observer.onNext(AuthenticationStatus.Error(AuthenticationError.UserCancelled))
                    break
                //If failed to login notify false and error message
                case .failed(_):
                    //Notify request failed error
                    observer.onNext(AuthenticationStatus.Error(AuthenticationError.Unknown))
                    break
                }
            })
            
            return Disposables.create()
        }
    }
}
