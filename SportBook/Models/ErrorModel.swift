//
//  ErrorModel.swift
//  SportBook
//
//  Created by Bui Minh Duc on 6/23/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import SwiftyJSON

public enum SportBookError  {
    case none
    case connectionFailure
    case unauthenticated
    case userCancelled
    case authenticationError(JSON)
    case apiError(JSON)
    case customMessage(String)
}

extension SportBookError : Error, CustomStringConvertible {
    public var description: String {
        switch self {
        case .none:
            return ""
        case .connectionFailure:
            return "connection_failure".localized
        case .unauthenticated:
            return "unauthenticated".localized
        case .userCancelled:
            return "user_cancel".localized
        case .authenticationError(let jsonError):
            var errorMessage = jsonError.arrayValue
                .map { $0.stringValue }
                .joined(separator: ". ")
            
            if errorMessage.isEmpty {
                errorMessage = jsonError.arrayValue
                    .map { $0.stringValue }
                    .joined(separator: ". ")
            }
            return errorMessage
        case .apiError(let jsonError):
            let errorMessage = jsonError.arrayValue
                .map { $0.stringValue }
                .joined(separator: ". ")
            return errorMessage
        case .customMessage(let message):
            return message
        }
    }
}
