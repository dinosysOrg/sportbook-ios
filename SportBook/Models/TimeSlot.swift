//
//  TimeSlot.swift
//  SportBook
//
//  Created by Bui Minh Duc on 6/27/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import Foundation

class TimeSlot {
    var day: DayOfWeek
    var blocks: [TimeBlock] = []
    
    init(day: DayOfWeek) {
        self.day = day
    }
    
    func toJson() -> [String: Any] {
        return [
            day.rawValue : blocks.map { $0.times }
        ]
    }
}
