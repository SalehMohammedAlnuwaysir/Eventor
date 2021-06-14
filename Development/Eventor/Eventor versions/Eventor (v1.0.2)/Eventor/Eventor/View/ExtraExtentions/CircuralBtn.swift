//
//  CircuralBtn.swift
//  Eventor
//
//  Created by Saleh on 25/06/1440 AH.
//  Copyright © 1440 Eventor. All rights reserved.
//

import UIKit

class CircuralBtn: UIButton {
    override func awakeFromNib() {
        self.frame = CGRect(x: 160, y: 100, width: 50, height: 50)
        self.layer.cornerRadius = 0.55 * self.bounds.size.width
        self.clipsToBounds = true
    }
}
