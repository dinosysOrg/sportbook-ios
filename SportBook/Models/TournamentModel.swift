//
//  TournamentModel.swift
//  SportBook
//
//  Created by DucBM on 6/7/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import Foundation
import SwiftyJSON

class TournamentModel {
    let name: String
    let startDate: String
    let endDate: String
        
    init(_ jsonData: JSON) {
        name = jsonData["name"].stringValue
        startDate = jsonData["start_date"].stringValue
        endDate = jsonData["end_date"].stringValue
    }
}
