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
    case tournament = "Tournament"
    case myTournament = "MyTournament"
}

fileprivate extension UIStoryboard {
    // Load a viewcontroller from main by name
    static func loadFromMain(_ identifier: String) -> UIViewController {
        return load(from: .main, identifier: identifier)
    }
    
    static func loadFromAuth(_ identifier: String) -> UIViewController {
        return load(from: .auth, identifier: identifier)
    }
    
    static func loadFromTournament(_ identifier: String) -> UIViewController {
        return load(from: .tournament, identifier: identifier)
    }
    
    static func loadFromMyTournament(_ identifier: String) -> UIViewController {
        return load(from: .myTournament, identifier: identifier)
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
    
    class func loadTournamentDetailViewController() -> TournamentDetailViewController {
        return loadFromTournament("TournamentDetailViewController") as! TournamentDetailViewController
    }
    
    class func loadSignUpTournamentViewController() -> SignUpTournamentViewController {
        return loadFromTournament("SignUpTournamentViewController") as! SignUpTournamentViewController
    }
    
    class func loadMyTournamentViewController() -> MyTournamentViewController {
        return loadFromTournament("MyTournamentViewController") as! MyTournamentViewController
    }
    
    class func loadMyTournamentDetailViewController() -> MyTournamentDetailViewController {
        return loadFromTournament("MyTournamentDetailViewController") as! MyTournamentDetailViewController
    }
    
    class func loadRuleViewController() -> RuleViewController {
        return loadFromMyTournament("RuleViewController") as! RuleViewController
    }

    
    // Add other app view controller load methods here ...
}
