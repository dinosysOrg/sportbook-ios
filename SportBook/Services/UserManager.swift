//
//  UserManager.swift
//  SportBook
//
//  Created by DucBM on 5/23/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import FacebookLogin
import SwiftyJSON

class UserManager {
    static let sharedInstance = UserManager()
    private init() {}
    
    //User
    private var _user : UserModel?
    
    var user : UserModel? {
        get {
            if _user == nil  && userJsonData != nil {
                _user =  UserModel(jsonData: userJsonData!)
            }
            return _user
        }
    }
    
    //User Data
    private var userJsonData: JSON? {
        get {
            let defaults = UserDefaults.standard
            if  let data = defaults.object(forKey: "userJsonData") as? String{
                return JSON.parse(data)
            }
            return nil
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue?.rawString(), forKey: "userJsonData")
        }
    }
    
    //Update user info
    func updateUserInfo(userInfo : JSON) {
        userJsonData = userInfo
    }
    
    //Clear user info
    func clearUserInfo() {
        self.userJsonData = nil
    }
}
