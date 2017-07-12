//
//  AuthManager.swift
//  SportBook
//
//  Created by DucBM on 5/26/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import SwiftyJSON

public enum AuthenticationStatus {
    case Authenticated
    case SignedUp
    case SignedOut
    case PasswordReset
    case Error(SportBookError)
    case None
}

class AuthManager {
    
    static var sharedInstance = AuthManager()
    private let maxAttempts = 3
    
    fileprivate let disposeBag = DisposeBag()
    
    private init() {}
    
    func storePushNotificationToken() {
        let iPhoneUDID =  UIDevice.current.identifierForVendor!.uuidString
        
        let userId = UserManager.sharedInstance.user?.uid
        
        DeviceProvider.request(.create(self.pushNotificationToken, iPhoneUDID, userId)).subscribe(onNext: { reponse in
            if 200..<300 ~= reponse.statusCode {
                print("Device Token stored successfully")
            } else {
                print("Device Token stored failed")
            }
        }).addDisposableTo(disposeBag)
    }
    
    func deletePushNotificationToken() {
        let iPhoneUDID =  UIDevice.current.identifierForVendor!.uuidString
        
        DeviceProvider.request(.delete(iPhoneUDID)).subscribe(onNext: { reponse in
            if 200..<300 ~= reponse.statusCode {
                print("Device Token deleted")
            } else {
                print("Device Token delete failed")
            }
        }).addDisposableTo(disposeBag)
    }
    
    func signIn(_ email: String, password: String) -> Observable<AuthenticationStatus> {
        return AuthenticationProvider.request(.signInWithEmail(email,password))
            .retry(maxAttempts).catchErrorJustReturn(Response(statusCode: 0, data: Data()))
            .flatMap(self.handleSignInResponse)
    }
    
    func signIn(_ fbToken: String) -> Observable<AuthenticationStatus> {
        return AuthenticationProvider.request(.signInWithFacebook(fbToken))
            .retry(maxAttempts).catchErrorJustReturn(Response(statusCode: 0, data: Data()))
            .flatMap(self.handleSignInResponse)
    }
    
    func signUp(_ email: String, password: String) -> Observable<AuthenticationStatus>{
        return AuthenticationProvider.request(.signUp(email, password))
            .retry(maxAttempts).catchErrorJustReturn(Response(statusCode: 0, data: Data()))
            .flatMap(self.handleSignUpResponse)
    }
    
    func signOut() -> Observable<AuthenticationStatus>{
        return AuthenticationProvider.request(.signOut)
            .retry(maxAttempts).catchErrorJustReturn(Response(statusCode: 0, data: Data()))
            .flatMap(self.handleSignOutResponse)
    }
    
    func resetPassword(_ email: String) -> Observable<AuthenticationStatus>{
        return AuthenticationProvider.request(.forgotPassword(email))
            .retry(maxAttempts).catchErrorJustReturn(Response(statusCode: 0, data: Data()))
            .flatMap(self.handleResetPasswordResponse)
    }
    
    func handleSignInResponse(_ response: Response) -> Observable<AuthenticationStatus> {
        return Observable<AuthenticationStatus>.create { observer in
            
            let jsonObject = JSON(response.data)
            print(jsonObject)
            
            if response.statusCode == 0 {
                observer.onNext(AuthenticationStatus.Error(SportBookError.connectionFailure))
            } else if 200..<300 ~= response.statusCode {
                
                let jsonObject = JSON(response.data)
                print(jsonObject)
                
                if let httpResponse = response.response as? HTTPURLResponse  {
                    if let headerFields = httpResponse.allHeaderFields as? [String: Any] {
                        AuthManager.sharedInstance.updateAuthData(with: headerFields)
                    }
                }
                
                UserManager.sharedInstance.updateUserInfo(userInfo: jsonObject["data"])
                
                //Request to store push notification token with this user
                self.storePushNotificationToken()
                
                observer.onNext(AuthenticationStatus.Authenticated)
            } else {
                let jsonError = JSON(response.data)["errors"]
                
                observer.onError(SportBookError.authenticationError(jsonError))
            }
            
            return Disposables.create()
        }
    }
    
    func handleSignUpResponse(_ response: Response) -> Observable<AuthenticationStatus> {
        return Observable<AuthenticationStatus>.create { observer in
            
            let jsonObject = JSON(response.data)
            print(jsonObject)
            
            if response.statusCode == 0 {
                observer.onNext(AuthenticationStatus.Error(SportBookError.connectionFailure))
            } else if 200..<300 ~= response.statusCode {
                observer.onNext(AuthenticationStatus.SignedUp)
            } else {
                let jsonError = JSON(response.data)["errors"]
                
                observer.onError(SportBookError.authenticationError(jsonError))
            }
            
            return Disposables.create()
        }
    }
    
    func handleSignOutResponse(_ response: Response) -> Observable<AuthenticationStatus> {
        return Observable<AuthenticationStatus>.create { observer in
            self.clearSession()
            
            observer.onNext(AuthenticationStatus.SignedOut)
            observer.onCompleted()

            return Disposables.create()
        }
    }
    
    func handleResetPasswordResponse(_ response: Response) -> Observable<AuthenticationStatus> {
        return Observable<AuthenticationStatus>.create { observer in
            
            let jsonObject = JSON(response.data)
            print(jsonObject)
            
            if response.statusCode == 0 {
                observer.onNext(AuthenticationStatus.Error(SportBookError.connectionFailure))
            } else if 200..<300 ~= response.statusCode {
                observer.onNext(AuthenticationStatus.PasswordReset)
            }
            else {
                let jsonError = JSON(response.data)["errors"]
                
                observer.onError(SportBookError.authenticationError(jsonError))
            }
            
            return Disposables.create()
        }
    }
    
    func clearSession(){
        self.AccessToken = nil
        self.TokenType = nil
        self.Client = nil
        self.Expiry = nil
        self.UID = nil
        
        //Delete push notification token with this user
        self.deletePushNotificationToken()
        UserManager.sharedInstance.clearUserInfo()
    }
}

extension AuthManager {
    
    //Authentication Flag
    var IsAuthenticated : Bool {
        if let token = AccessToken {
            return !token.isEmpty
        }
        return false
    }
    
    //Access Token
    var AccessToken: String? {
        get {
            let defaults = UserDefaults.standard
            let token = defaults.object(forKey: "accessToken") as? String
            return token
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "accessToken")
            defaults.synchronize()
        }
    }
    
    //Type of token
    var TokenType: String? {
        get {
            let defaults = UserDefaults.standard
            let tokenType = defaults.object(forKey: "tokenType") as? String
            return tokenType
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "tokenType")
            defaults.synchronize()
        }
    }
    
    //UID
    var UID: String? {
        get {
            let defaults = UserDefaults.standard
            let uid = defaults.object(forKey: "uid") as? String
            return uid ?? ""
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "uid")
            defaults.synchronize()
        }
    }
    
    //Access Token Expiration Time
    var Expiry: Int? {
        get {
            let defaults = UserDefaults.standard
            let expiry = defaults.object(forKey: "expiry") as? Int
            return expiry ?? 0
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "expiry")
            defaults.synchronize()
        }
    }
    
    //Client
    var Client: String? {
        get {
            let defaults = UserDefaults.standard
            let client = defaults.object(forKey: "client") as? String
            return client ?? ""
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "client")
            defaults.synchronize()
        }
    }
    
    //Push notification token
    
    var pushNotificationToken: String {
        get {
            let defaults = UserDefaults.standard
            let token = defaults.object(forKey: "push_notification_token") as? String
            return token ?? ""
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "push_notification_token")
            defaults.synchronize()
        }
    }
    
    //Flag to detect if user first time open application
    var firstLaunch: Bool? {
        get {
            let defaults = UserDefaults.standard
            return defaults.object(forKey: "firstLaunch") as? Bool
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "firstLaunch")
            defaults.synchronize()
        }
    }
    
    func toDictionary() -> [String:String] {
        return ["Access-Token": AccessToken ?? "",
                "Client": Client ?? "",
                "Expiry": String(describing: Expiry) ,
                "Token-Type": TokenType ?? "",
                "Uid": UID ?? ""]
    }
    
    func updateAuthData(with data : [String:Any]){
        if let token = data["Access-Token"] as? String {
            AccessToken = token
        }
        
        if let clientData = data["Client"] as? String {
            Client = clientData
        }
        
        if let expiryData = data["Expiry"] as? Int {
            Expiry = expiryData
        }
        
        if let typeData = data["Token-Type"] as? String {
            TokenType = typeData
        }
        
        if let uidData = data["Uid"] as? String {
            UID = uidData
        }
    }
}
