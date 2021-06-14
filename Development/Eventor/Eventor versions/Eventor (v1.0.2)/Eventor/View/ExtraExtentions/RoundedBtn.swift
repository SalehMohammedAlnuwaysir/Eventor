//
//  blueRoundedBtn.swift
//  
//
//  Created by YAZEED NASSER on 08/10/2018.
//  Copyright © 2018 YAZEED NASSER. All rights reserved.
//

import UIKit

class RoundedBtn: UIButton {
    override func awakeFromNib() {
//        self.backgroundColor = UIColor(red: 0.121, green: 0.837, blue: 0.870, alpha: 1.000)

        self.alpha = 0.9
        self.layer.cornerRadius = 15
        self.setTitleColor(UIColor.white, for: .normal)
        
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 6)
        self.layer.shadowRadius = 5
        
    }
 

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
