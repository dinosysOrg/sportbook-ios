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
    let id: String
    let name: String
    let startDate: String
    let endDate: String
        
    init(_ jsonData: JSON) {
        id = jsonData["id"].stringValue
        name = jsonData["name"].stringValue
        startDate = jsonData["start_date"].stringValue
        endDate = jsonData["end_date"].stringValue
    }
}
