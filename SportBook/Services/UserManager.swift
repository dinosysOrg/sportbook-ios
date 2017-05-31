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
    
    //Clear User Data
    func clear() {
        self.userData = nil
    }
}
