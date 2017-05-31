//
//  SportBookAPI.swift
//  SportBook
//
//  Created by DucBM on 5/23/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import Foundation
import RxSwift
import Moya

struct SportBookAPI {
    private static let BaseURL = "http://sportbook-staging.herokuapp.com/api/"
    private static let Version = "v1"
    static var URL : String {
        return BaseURL + Version
    }
}

