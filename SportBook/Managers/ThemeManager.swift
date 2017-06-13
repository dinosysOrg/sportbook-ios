//
//  ThemeManager.swift
//  SportBook
//
//  Created by DucBM on 5/30/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField

class ThemeManager {
    
    static func applyTheme() {
        
        let proxyNormalTextField = SkyFloatingLabelTextField.appearance()
        proxyNormalTextField.tintColor = SportBookColors.overcastBlue
        proxyNormalTextField.selectedTitleColor = SportBookColors.overcastBlue
        proxyNormalTextField.selectedLineColor = SportBookColors.overcastBlue
        proxyNormalTextField.errorColor = UIColor.red
        
        let proxyNormalImageView = UIImageView.appearance()
        proxyNormalImageView.image = UIImage(named: "placeholder.jpeg")
    }
}

class SportBookColors {
    static let overcastBlue = UIColor(red: 0, green: 187/255, blue: 204/255, alpha: 1.0)
}

//Font, style...etc...
class SportBookStyles {
//    static let bodyFont = UIFont(name: "ArialMT" , size: 14.0 )
//    static let titleFont = UIFont(name: "Avenir-Light" , size: 32.0 )
//    static let normalButtonFont = UIFont(name: "ArialMT" , size: 14.0 )
//    static let importantButtonFont = UIFont(name: "Arial-BoldMT" , size: 14.0 )
}
