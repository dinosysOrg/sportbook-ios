//
//  Validation.swift
//  SportBook
//
//  Created by DucBM on 5/26/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import Foundation

class Validation {
    static func emailValid(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}
