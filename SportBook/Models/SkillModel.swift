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
    let name: String
    
    init(_ sampleData : String) {
        name = sampleData
    }
    
    init(_ jsonData: JSON) {
        name = jsonData["name"].stringValue
    }
}
