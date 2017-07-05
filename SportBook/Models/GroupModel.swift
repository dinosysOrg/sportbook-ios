//
//  GroupModel.swift
//  SportBook
//
//  Created by Bui Minh Duc on 6/29/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import Foundation
import SwiftyJSON

struct GroupModel {
    let name : String
    let teams : [TeamModel]?
    let opponents: [OpponentModel]?
    let createTime: String?
    
    init(_ jsonData : JSON) {
        self.name = jsonData["group_name"].stringValue
        self.teams = jsonData["teams"].array?.map { TeamModel($0) }
        self.opponents = jsonData["opponent_teams"].array?.map { OpponentModel($0) }
        self.createTime = jsonData["group_time_create"].string
    }
}
