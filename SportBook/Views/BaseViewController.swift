//
//  BaseViewController.swift
//  SportBook
//
//  Created by DucBM on 5/18/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import UIKit

class BaseViewController : UIViewController {
    
    //Dismiss keybord in View Controller
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    //Temporary error showing
    func showError(_ error: AuthenticationError) {
        var title: String = ""
        var message: String = ""
        
        switch error {
        case .Unknown:
            title = "error_title".localized
            message = "error_unknown".localized
            break
        case .UserCancelled:
            return
        case .Server, .BadReponse:
            title = "error_title".localized
            message = "error_server".localized
            break
        case .BadCredentials:
            title = "bad_credentials".localized
            message = "user_not_exist".localized
            break
        case .Custom(let error):
            title = "sign_in_fail".localized
            message = error.description
            break
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok".localized, style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
