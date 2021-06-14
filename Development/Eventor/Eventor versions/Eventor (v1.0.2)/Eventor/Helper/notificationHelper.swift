//
//  notificationHelper.swift
//  Eventor
//
//  Created by YAZEED NASSER on 05/04/2019.
//  Copyright © 2019 Eventor. All rights reserved.
//

import Foundation

//NOTE: Tocall this object go like this -> FBDBHandler.FBDBHandlerObj.(funcName)
class notificationHelper{
    static let notificationHelperObj: notificationHelper = notificationHelper.init()
 
    var notifyVie:UIView = UIView.init()
    var notifyLbl:UILabel = UILabel.init()
    var callerVC:UIViewController? = nil
    var allowToShow = true
    
    private init(){
        
    }
    
    func styleElements(){
        if let callerVC = callerVC{
            notifyVie = UIView.init()
            notifyLbl = UILabel.init()
            
            notifyVie.frame.size = CGSize(width: (callerVC.view.frame.width - 20) , height: 60)
            notifyVie.center = callerVC.view.center
            notifyVie.center.y = 0
            notifyVie.layer.cornerRadius = (notifyVie.frame.height / 2)
            
            notifyVie.layer.shadowOpacity = 0.5
            notifyVie.layer.shadowOffset.height = 5.0
            notifyVie.layer.shadowRadius = 5.0
            
            //notifyVie.center.y = 100
            notifyVie.clipsToBounds = false

            notifyLbl.frame.size = CGSize(width: (notifyVie.frame.width - 5) , height: (notifyVie.frame.height/2))
            notifyLbl.center = notifyVie.center
            notifyLbl.textColor = UIColor.white
            notifyLbl.textAlignment = .center
        }
    }
    
    func showError(callerVC:UIViewController,Err:String,color:UIColor){
        if allowToShow {
            allowToShow = false
            self.callerVC = callerVC
            //seting size
            styleElements()
            
            //seting collor
            notifyVie.backgroundColor = color
            notifyVie.layer.shadowColor = color.cgColor
            
            //start howing
            if let callerVC = self.callerVC{
                showNotifView(VC:callerVC,msg:Err)
            }
        }
    }
    
    private func showNotifView(VC:UIViewController,msg:String){
        VC.view.addSubview(self.notifyVie)
        self.notifyVie.addSubview(self.notifyLbl)
        notifyLbl.text = msg
        self.notifyVie.alpha = 0

        //showing view
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            UIView.animate(withDuration: 0.3, animations: {
                self.notifyVie.transform = CGAffineTransform(translationX: 0, y: 130)
                self.notifyLbl.transform = CGAffineTransform(translationX: 0, y: 30)
                self.notifyVie.alpha = 0.9

            })
        }
        
        //hide after 5 sec
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            UIView.animate(withDuration: 0.4, animations: {
                self.notifyVie.transform = CGAffineTransform(translationX: 0, y: -130)
                self.notifyLbl.transform = CGAffineTransform(translationX: 0, y: -30)
                self.notifyVie.alpha = 0
            })
        }
        
        
        //delete views
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) {
            self.notifyVie.removeFromSuperview()
            self.notifyLbl.removeFromSuperview()
            self.allowToShow = true

        }
       
    } //end methode
}
