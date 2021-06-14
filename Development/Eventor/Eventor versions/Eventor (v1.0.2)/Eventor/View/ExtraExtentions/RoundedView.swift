//
//  RoundedView.swift
//  Eventor
//
//  Created by Saleh on 25/06/1440 AH.
//  Copyright © 1440 Eventor. All rights reserved.
//

import UIKit

class RoundedView: UIView {

    override func awakeFromNib() {
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
    }
}
