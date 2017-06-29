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
    var name : String
    var teams : [TeamModel]
    
    init?(_ jsonData : JSON) {
        self.name = jsonData["group_name"].stringValue
        self.teams = jsonData["teams"].arrayValue.map { TeamModel($0)! }
    }
}
