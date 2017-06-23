//
//  UserModel.swift
//  SportBook
//
//  Created by DucBM on 5/23/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserModel {
    var id: Int?
    var provider: String?
    var note: String?
    var uid: String?
    var image: String?
    var address: String?
    var club: String?
    var email: String?
    var slug: String?
    var birthday: String?
    var facebookCredentials: String?
    var name: String?
    var nickName: String?
    var facebookUid: String?
    var phoneNumber: String?
    var skillId: Int?
    
    init(jsonData : JSON) {
        
        self.id = jsonData["id"].int
        
        self.provider = jsonData["provider"].string
        
        self.note = jsonData["note"].string
        
        self.uid = jsonData["uid"].string
        
        self.image = jsonData["image"].string
        
        self.address = jsonData["address"].string
        
        self.club = jsonData["club"].string
        
        self.email = jsonData["email"].string
        
        self.slug = jsonData["slug"].string
        
        self.birthday = jsonData["birthday"].string
        
        self.facebookCredentials = jsonData["facebook_credentials"].string
        
        self.name = jsonData["name"].string
        
        self.nickName = jsonData["nickname"].string
        
        self.facebookUid = jsonData["facebook_uid"].string
        
        self.phoneNumber = jsonData["phone_number"].string
        
        self.skillId = jsonData["skill_id"].int
    }
    
    //Check if this user has signed up any tournament before
    var hasTournamentProfile : Bool {
        guard let profileName = name, let _ = phoneNumber, let profileAddress = address,
            let _ = skillId else {
                return false
        }
        
        if profileName.isEmpty || profileAddress.isEmpty {
            return false
        }
        
        return true
    }
}
