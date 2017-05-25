//
//  ErrorModel.swift
//  SportBook
//
//  Created by DucBM on 5/25/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import Foundation

struct ApiError : Error {
    var message : String = "Lỗi khi gửi yêu cầu đến server!!!"
}
