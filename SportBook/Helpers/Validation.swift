//
//  Validation.swift
//  SportBook
//
//  Created by DucBM on 5/26/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import Foundation

class Validation {
    static func emailValid(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    static func phoneValid(_ phone: String) -> Bool {
        let phoneRegEx = "(\\+84|0)\\d{9,10}"
        let phoneTest = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        return phoneTest.evaluate(with: phone)
    }
    
    static func birhdateValid(_ birthdate: String) -> Bool {
        let brithdateRegEx = "^(19|20)\\d\\d[- /.](0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01])$"
        let birthdateTest = NSPredicate(format:"SELF MATCHES %@", brithdateRegEx)
        return birthdateTest.evaluate(with: birthdate)
    }
}
