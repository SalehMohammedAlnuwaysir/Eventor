//
//  refrishingHanler.swift
//  Eventor
//
//  Created by YAZEED NASSER on 27/03/2019.
//  Copyright © 2019 Eventor. All rights reserved.
//

import Foundation
import UIKit

class refrishingHanler{
    static let refrishingHanlerObj: refrishingHanler = refrishingHanler.init()
    var isRefreshing:Bool = false
    let viewOne:UIView = UIView.init(frame: CGRect.init())
    let viewTow:UIView = UIView.init(frame: CGRect.init())
    let reFreshBGView:UIView = UIView.init(frame: CGRect.init())
    
    private init(){
}

    //give it the viwe of the vc just wite it like this  any whare in your codeVVV
    // refrishingHanler.refrishingHanlerObj.startRefrising(view: self.view)  <- just copy this and it will work
    func startRefrising(view:UIView){
        view.endEditing(true)

        isRefreshing = true
        
        let viewCenter =  view.center
        reFreshBGView.frame.size  = view.frame.size
        reFreshBGView.center = viewCenter
        
        
        viewOne.backgroundColor = .red
        viewTow.backgroundColor = .orange
        reFreshBGView.backgroundColor = .white
        
        
        viewOne.center.y = viewCenter.y
        viewTow.center.y = viewCenter.y
        viewOne.alpha = 0
        viewTow.alpha = 0
        reFreshBGView.alpha = 0
        
        view.addSubview(reFreshBGView)
        view.addSubview(viewOne)
        view.addSubview(viewTow)

        
        
        
        UIView.animate(withDuration: 0.5 , animations: {
            
            self.viewOne.layer.cornerRadius = 80/2
            self.viewTow.layer.cornerRadius = 50/2
            
            self.viewOne.frame.size = CGSize(width: 80 , height: 80)
            self.viewTow.frame.size = CGSize(width: 50 , height: 50)
            
            
            self.viewOne.center = viewCenter
            self.viewTow.center = viewCenter
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.viewOne.alpha = 0.8
                self.viewTow.alpha = 0.8
                self.reFreshBGView.alpha = 0.2

                
                
            }
            
        })
        
        
        let vOneframe = CGSize(width: 80 , height: 80)
        let Vtowframe = CGSize(width: 50 , height: 50)
        
        
        UIView.animate(withDuration: 0.5, delay: 0.1, options: [.repeat, .autoreverse], animations: {
            
            self.viewOne.frame.size = Vtowframe
            self.viewTow.frame.size = vOneframe
            
        }, completion: { (finished: Bool) -> Void in
            
            
        })
        
        
    }
    
    //give it the same view you gave the [startRefrising()]
    //past this in the completion of the function VVV
    //refrishingHanler.refrishingHanlerObj.endRefrising(view: self.view)  <- just copy this and it will work
    
    func endRefrising(view:UIView){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isRefreshing = false
            self.viewOne.layer.removeAllAnimations()
            self.viewTow.layer.removeAllAnimations()
            
            self.viewOne.removeFromSuperview()
            self.viewTow.removeFromSuperview()
            self.reFreshBGView.removeFromSuperview()
            
        }
    }
    
    
    
    
}
