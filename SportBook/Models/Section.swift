//
//  TableViewSection.swift
//  SportBook
//
//  Created by Bui Minh Duc on 6/30/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import Foundation

struct Section {
    var name: String!
    var items: [String]!
    var collapsed: Bool!
    
    init(name: String, items: [String], collapsed: Bool = true) {
        self.name = name
        self.items = items
        self.collapsed = collapsed
    }
}
