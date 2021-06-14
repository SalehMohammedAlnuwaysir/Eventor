//
//  resultsAndAlerts.swift
//  LCApp
//
//  Created by YAZEED NASSER on 08/01/2019.
//  Copyright © 2019 LawClub. All rights reserved.
//

import Foundation
import UIKit

let resultsAndAlertsObj:resultsAndAlerts = resultsAndAlerts.init()

class resultsAndAlerts{
    
    func showErorr(reson:String ,theLbl: UILabel ){
        theLbl.backgroundColor = .red
        theLbl.textColor = UIColor.white

        theLbl.text = reson
        UIView.animate(withDuration: 2, animations: {
            theLbl.alpha = 8
        })
        UIView.animate(withDuration: 6, animations: {
            theLbl.alpha = 0
        })
    }
    
    func showSuccess(reson:String ,theLbl: UILabel ){
        theLbl.backgroundColor = .green
        theLbl.textColor = UIColor.white
        theLbl.text = reson
        UIView.animate(withDuration: 2, animations: {
            theLbl.alpha = 8
        })
        UIView.animate(withDuration: 4, animations: {
            theLbl.alpha = 0
        })
    }
        
        func showMessage(reson:String ,theLbl: UILabel ){
            theLbl.backgroundColor = .orange
            theLbl.textColor = UIColor.white
            theLbl.text = reson
            UIView.animate(withDuration: 4, animations: {
                theLbl.alpha = 8
            })
            UIView.animate(withDuration: 6, animations: {
                theLbl.alpha = 0
            })
    }
    
 
    
}

