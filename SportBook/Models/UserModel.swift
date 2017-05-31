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
    var id : Int?
    var skillId : String?
    var facebookCredentials : String?
    var provider : String?
    var uid : String?
    var phoneNumber : String?
    var note : String?
    var facebookUID : String?
    var image : String?
    var address : String?
    var slug : String?
    var nickName : String?
    var email : String?
    var name : String?
    var skillLevel : Int?
    
    init(data : Data) {
        
        let jsonData = JSON(data)["data"]
        
        self.id = jsonData["id"].int
        
        self.skillId = jsonData["skill_id"].string
        
        self.facebookCredentials = jsonData["facebook_credentials"].string
        
        self.provider = jsonData["provider"].string
        
        self.phoneNumber = jsonData["phone_number"].string
        
        self.note = jsonData["note"].string
        
        self.facebookUID = jsonData["facebook_uid"].string
        
        self.image = jsonData["image"].string
        
        self.address = jsonData["address"].string
        
        self.slug = jsonData["slug"].string
        
        self.nickName = jsonData["nickname"].string
        
        self.email = jsonData["email"].string
        
        self.name  = jsonData["name"].string
        
        self.skillLevel = jsonData["skill_level"].int
    }
}
