//
//  motionViewEff.swift
//  LCApp
//
//  Created by YAZEED NASSER on 19/01/2019.
//  Copyright © 2019 LawClub. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func applyViewMotionEffect (toView view:UIView,magnitude:Float) {
        let XMotion = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        XMotion.minimumRelativeValue = -magnitude
        XMotion.maximumRelativeValue = magnitude
        
        let YMotion = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        YMotion.minimumRelativeValue = -magnitude
        YMotion.maximumRelativeValue = magnitude
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [XMotion,YMotion]
        
        view.addMotionEffect(group)
        
    }
    
    // you just need to call this method --V in the view didload
    
    //            applyViewMotionEffect(toView : --- , magnitude : --- )
    //example:    applyViewMotionEffect(toView : theHomeView , magnitude : 10 )
    
}
