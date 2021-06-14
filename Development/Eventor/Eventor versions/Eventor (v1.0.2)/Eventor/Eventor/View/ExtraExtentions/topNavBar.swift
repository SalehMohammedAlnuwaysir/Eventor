//
//  topNavBar.swift
//  Eventor
//
//  Created by YAZEED NASSER on 05/02/2019.
//  Copyright © 2019 Eventor. All rights reserved.
//

import  UIKit

class topNavBar:UINavigationItem {
    var layer:CAGradientLayer = (superclass()?.layerClass! as? CAGradientLayer)!
    


    @IBInspectable var firstColor: UIColor = UIColor.white {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var secondColor: UIColor = UIColor.white {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var horizontalGradient: Bool = false {
        didSet {
            updateView()
        }
    }
    
    

    func updateView() {
        let layer = self.layer as! CAGradientLayer
        layer.colors = [ firstColor.cgColor, secondColor.cgColor ]

        if (horizontalGradient) {
            layer.startPoint = CGPoint(x: 0.0, y: 0.5)
            layer.endPoint = CGPoint(x: 1.0, y: 0.5)
        } else {
            layer.startPoint = CGPoint(x: 0, y: 0)
            layer.endPoint = CGPoint(x: 0, y: 1)
        }
    }
    
}


extension UINavigationBar {
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: self.frame.size.width, height: 200)
    }
}
