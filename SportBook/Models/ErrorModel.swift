//
//  ErrorModel.swift
//  SportBook
//
//  Created by DucBM on 5/25/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import Foundation

public enum SportBookError {
    case Unknown
    case ApiRequest(String)
    case InvalidInput
    case PasswordTooShort
}

extension SportBookError : Error, CustomStringConvertible {
    public var description : String {
        switch self {
        case .ApiRequest(let message):
            return message
        case .InvalidInput:
            return "Dữ liệu không hợp lệ!!!"
        default:
            return "Lỗi!!!"
        }
    }
}
