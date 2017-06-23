//
//  SportBookError.swift
//  SportBook
//
//  Created by DucBM on 5/31/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import SwiftyJSON
import UIKit

public enum SportBookError  {
    case None
    case ConnectionFailure
    case Unauthenticated
    case AuthenticationError(JSON)
    case ApiError(JSON)
    case UserCancelled
    case Custom(String)
}

extension SportBookError : Error, CustomStringConvertible {
    public var description: String {
        switch self {
        case .None:
            return ""
        case .ConnectionFailure:
            return "connection_failure".localized
        case .AuthenticationError(let jsonError):
            let errorMessage = jsonError["full_messages"].stringValue
            return errorMessage
        case .ApiError(let jsonError):
            let errorMessage = jsonError["full_messages"].stringValue
            return errorMessage
        case .Custom(let message):
            return message
        default:
            return "error_system".localized
        }
    }
}


class ErrorManager {
    static let sharedInstance = ErrorManager()
    private init() {}
    
    //Temporary error showing
    func showError(viewController: UIViewController, error: SportBookError) {
        let title: String = "error_title".localized
        let message = error.description
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok".localized, style: .cancel, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func showMessage(viewController: UIViewController, title: String = "application_name".localized, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok".localized, style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
}
