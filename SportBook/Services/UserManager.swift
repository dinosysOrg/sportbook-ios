//
//  UserManager.swift
//  SportBook
//
//  Created by DucBM on 5/23/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import Foundation
import FacebookLogin

class UserManager {
    static let sharedInstance = UserManager()
    private init() {}
    
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
            return token ?? ""
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
            return tokenType ?? ""
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
            let code = defaults.object(forKey: "client") as? String
            return code ?? ""
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "client")
            defaults.synchronize()
        }
    }
    
    //User
    private var _user : UserModel?
    
    var User : UserModel? {
        get {
            if _user == nil  && userData != nil {
                _user =  UserModel(data: userData!)
            }
            return _user
        }
    }
    
    //User Data
    var userData: Data? {
        get {
            let defaults = UserDefaults.standard
            if  let data = defaults.object(forKey: "userData") as? Data{
                return data
            }
            return nil
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "userData")
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
    
    func update(with data : [String:Any]){
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
    
    func logout() {
        self.AccessToken = nil
        self.Client = nil
        self.Expiry = nil
        self.TokenType = nil
        self.UID = nil
        self.userData = nil
    }
}
