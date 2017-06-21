//
//  SkillModel.swift
//  SportBook
//
//  Created by DucBM on 6/12/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import Foundation
import SwiftyJSON

struct SkillModel {
    let id: Int
    let name: String
    
    init(_ jsonData: JSON) {
        id = jsonData["id"].intValue
        name = jsonData["name"].stringValue
    }
}
