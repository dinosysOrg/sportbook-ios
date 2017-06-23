//
//  Date+Extension.swift
//  SportBook
//
//  Created by Bui Minh Duc on 6/23/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import Foundation

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        return dateFormatter.string(from: self)
    }
}
