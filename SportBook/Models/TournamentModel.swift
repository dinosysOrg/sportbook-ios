//
//  TournamentModel.swift
//  SportBook
//
//  Created by DucBM on 6/7/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import Foundation
import SwiftyJSON

struct TournamentModel {
    let id: Int
    let name: String
    let startDate: String
    let endDate: String
    let teams: [TeamModel]
    let competitionSchedule: String
    let competitionMode: String
    let competitionFee: String
    
    init(_ jsonData: JSON) {
        id = jsonData["id"].intValue
        name = jsonData["name"].stringValue
        startDate = jsonData["start_date"].stringValue
        endDate = jsonData["end_date"].stringValue
        teams = jsonData["teams"].arrayValue.map { TeamModel($0) }
        competitionSchedule = jsonData["competition_schedule"].stringValue
        competitionMode = jsonData["competition_mode"].stringValue
        competitionFee = jsonData["competition_fee"].stringValue
    }
}
