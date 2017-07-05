//
//  OpponentModel.swift
//  SportBook
//
//  Created by Bui Minh Duc on 7/5/17.
//  Copyright © 2017 dinosys. All rights reserved.
//


import Foundation
import SwiftyJSON

struct OpponentModel {
    let teamId: Int
    let teamName: String
    let inviterId: Int?
    let inviteeId: Int?
    let invivatationId: Int?
    let invitationStatus: String?
    
    init (_ jsonData: JSON) {
        self.teamId = jsonData["team_id"].intValue
        self.teamName = jsonData["team_name"].stringValue
        self.invivatationId = jsonData["invitation_id"].intValue
        self.inviterId = jsonData["invitation_inviter_id"].int
        self.inviteeId = jsonData["invitation_invitee_id"].int
        self.invitationStatus = jsonData["invitation_status"].string
    }
}
