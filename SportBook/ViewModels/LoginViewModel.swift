//
//  LoginViewModel.swift
//  SportBook
//
//  Created by DucBM on 5/18/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON
import Moya
import FacebookCore
import FacebookLogin

class LoginViewModel : AuthenticationDelegate {
    
    let disposeBag = DisposeBag()
    
    var email : String! = ""
    
    var password : String! = ""
    
    func loginWithEmail() -> Observable<Void> {
        return Observable<Void>.create { observer in
            //Valid data here
            
            AuthenticationProvider.request(Authentication.signInWithEmail(self.email, self.password)).flatMap { response in
                return self.handleResponse(response)
                }.subscribe(onError: { error in
                    //Notify error)
                }, onCompleted: { _ in
                    observer.onNext()
                }).addDisposableTo(self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    func loginFacebook(viewcontroller : UIViewController) -> Observable<Void> {
        
        let loginManager = LoginManager()
        
        //Make sure Facebook logged out
        loginManager.logOut()
        
        //Create observable to do login facebook and return result
        return Observable<Void>.create { observer in
            
            //Init permission
            let permission = [ReadPermission.publicProfile, ReadPermission.userFriends]
            
            //Login with permision, view controller and completion closure
            loginManager.logIn(permission, viewController: viewcontroller, completion: {  result in
                
                switch result {
                //If success return notify and acess token
                case .success(_, _, let accessToken):
                    AuthenticationProvider.request(.signInWithFacebook(accessToken.authenticationToken)).flatMap { response in
                        return self.handleResponse(response)
                    }.subscribe(onError: { error in
                        //Notify error
                    }, onCompleted: { _ in
                        observer.onNext()
                    }).addDisposableTo(self.disposeBag)
                    
                    //Do sign in with Facebook
                    break
                //If user cancelled notify false and message
                case .cancelled:
                    //Notify cancelled error
                    break
                //If failed to login notify false and error message
                case .failed(let error):
                     //Notify request failed error
                    break
                }
                
                //Complete and dispose
                observer.onCompleted()
            })
            
            return Disposables.create()
        }
    }
}
