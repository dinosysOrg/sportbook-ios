//
//  ResponseModel.swift
//  SportBook
//
//  Created by DucBM on 5/25/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import Foundation
import SwiftyJSON
import Moya

class ResponseModel {
    var code : Int = 0
    var status : String?
    var data : Data
    var error : SportBookError?
    
    required init(response: Response) {
        
        self.code = response.statusCode
        self.data = response.data
        
        let jsonData = JSON(response.data)
        
        self.status = jsonData["status"].string
        
        let errorMessage = jsonData["errors"]["full_messages"]
            .arrayValue.map { $0.stringValue }.joined(separator: ". ")
        
        self.error = SportBookError.ApiRequest(errorMessage)
    }
}
