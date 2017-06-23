//
//  TeamModel.swift
//  SportBook
//
//  Created by Bui Minh Duc on 6/22/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import Foundation
import SwiftyJSON

public enum TeamStatus : String {
    case registered = "registered"
    case paid = "paid"
}

struct TeamModel {
    let id: Int
    let tournamentId: Int
    let name: String
    let createdDate: String
    let updatedDate: String
    let status: TeamStatus
    let venueRanking: [String]
    
    init(_ jsonData: JSON) {
        id = jsonData["id"].intValue
        tournamentId    = jsonData["tournament_id"].intValue
        name = jsonData["name"].stringValue
        createdDate = jsonData["created_at"].stringValue
        updatedDate = jsonData["updated_at"].stringValue
        venueRanking = jsonData["venue_ranking"].arrayValue.map { $0.stringValue }
        status = TeamStatus(rawValue: jsonData["status"].stringValue)!
    }
}
