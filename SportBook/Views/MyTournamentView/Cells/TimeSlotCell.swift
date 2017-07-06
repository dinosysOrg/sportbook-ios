//
//  TimeSlotCell.swift
//  SportBook
//
//  Created by Bui Minh Duc on 6/27/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import UIKit

class TimeSlotCell: UICollectionViewCell {
    
    @IBOutlet weak var imgSelection: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func select(selected: Bool) {
        self.imgSelection.isHidden = !selected
    }
}

