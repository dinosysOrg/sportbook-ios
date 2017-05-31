//
//  UIStoryboard+Extension.swift
//  SportBook
//
//  Created by DucBM on 5/18/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import UIKit

// Enum case for each storyboard in your project
fileprivate enum Storyboard : String {
    case main = "Main"
    case auth = "Authentication"
}

fileprivate extension UIStoryboard {
    // Load a viewcontroller from main by name
    static func loadFromMain(_ identifier: String) -> UIViewController {
        return load(from: .main, identifier: identifier)
    }
    
    static func loadFromAuth(_ identifier: String) -> UIViewController {
        return load(from: .auth, identifier: identifier)
    }

    // Load storyboard by name
    static func load(from storyboard: Storyboard, identifier: String) -> UIViewController {
        let uiStoryboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        return uiStoryboard.instantiateViewController(withIdentifier: identifier)
    }
}

// MARK: App View Controllers

extension UIStoryboard {
    class func loadMainViewController() -> MainViewController {
        return loadFromMain("MainViewController") as! MainViewController
    }
    
    class func loadLoginViewController() -> LoginViewController {
        return loadFromAuth("LoginViewController") as! LoginViewController
    }
    
    // Add other app view controller load methods here ...
}
