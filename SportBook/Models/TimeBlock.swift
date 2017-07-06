//
//  TimeBlock.swift
//  SportBook
//
//  Created by Bui Minh Duc on 6/27/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import Foundation

public enum TimeBlock: String {
    case morning = "9:AM - 12:AM"
    case afternoon = "1:PM - 4:PM"
    case evening = "5:PM - 9:PM"
}

extension TimeBlock {
    var description : String {
        get {
            return self.rawValue
        }
    }
    
    var times : [Int] {
        get {
            switch self {
            case .morning:
                return [9,10,11]
            case .afternoon:
                return [13,14,15]
            case .evening:
                return [17,18,19,20]
            }
        }
    }
    
    static func parse(_ block : [Int]) -> TimeBlock {
        if block == TimeBlock.morning.times {
            return TimeBlock.morning
        } else if block == TimeBlock.afternoon.times {
            return TimeBlock.afternoon
        } else {
            return TimeBlock.evening
        }
    }
}
