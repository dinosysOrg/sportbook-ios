//
//  ProfileViewController.swift
//  SportBook
//
//  Created by DucBM on 5/24/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class ProfileViewController : BaseViewController {
    
    @IBAction func btnLogoutTapped(_ sender: UIButton) {
        AuthenticationProvider.request(.signOut).subscribe(onNext: { result in
            print(JSON(result.data))
            UserManager.sharedInstance.clear()
            AuthManager.sharedInstance.signOut()
        })
    }
}
