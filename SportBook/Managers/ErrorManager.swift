//
//  SportBookError.swift
//  SportBook
//
//  Created by DucBM on 5/31/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import Foundation
import UIKit

public enum SportBookError  {
    case Unknown
    case UserCancelled
    case Custom(String)
}

extension SportBookError : Error, CustomStringConvertible {
    public var description: String {
        switch self {
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
        var message: String = ""
        
        switch error {
        case .Custom(let error):
            message = error.description
            break
        default:
            message = "error_unknown".localized
            break
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok".localized, style: .cancel, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
}
