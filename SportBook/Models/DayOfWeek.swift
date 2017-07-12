//
//  DayOfWeek.swift
//  SportBook
//
//  Created by Bui Minh Duc on 6/27/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import Foundation

public enum DayOfWeek: String {
    case monday = "monday"
    case tuesday = "tuesday"
    case wednesday = "wednesday"
    case thursday = "thursday"
    case friday = "friday"
    case saturday = "saturday"
    case sunday = "sunday"
}

extension DayOfWeek {
    var description: String {
        get {
            return self.rawValue.localized
        }
    }
    
    var shortDescription: String {
        get {
            return String(self.description.characters.first!)
        }
    }
}
