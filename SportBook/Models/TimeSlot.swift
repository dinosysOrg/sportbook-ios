//
//  TimeSlot.swift
//  SportBook
//
//  Created by Bui Minh Duc on 6/27/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import Foundation

struct TimeSlot {
    var day: DayOfWeek
    var block: [TimeBlock]
    
    func toJson() -> [String:Any] {
        return [ day.rawValue : block]
    }
}
