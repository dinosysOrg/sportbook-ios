//
//  LocationModel.swift
//  SportBook
//
//  Created by DucBM on 6/19/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import Foundation
import SwiftyJSON

struct City {
    var name: String!
    let districts: [String]
    
    init(jsonData : JSON) {
        self.name = jsonData["name"].string
        self.districts = jsonData["districts"].arrayValue.map { $0.stringValue }
    }
}
