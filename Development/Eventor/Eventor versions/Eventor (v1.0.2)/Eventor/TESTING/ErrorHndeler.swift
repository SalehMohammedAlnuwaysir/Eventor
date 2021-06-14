//
//  ErrorHndeler.swift
//  Eventor
//
//  Created by YAZEED NASSER on 25/03/2019.
//  Copyright © 2019 Eventor. All rights reserved.
//

import Foundation
class ErrorHndeler{
    static let ErrorHndelerObj:ErrorHndeler = ErrorHndeler.init()
    
    private init (){
        
    }
    
    func showError(userViwe:UIView,ErrMsg:String){
        let ErrorViewHight:CGFloat = 700
        let errVieFrame:CGRect = CGRect(x: 0, y: -(ErrorViewHight), width: userViwe.frame.width, height: ErrorViewHight)
        let errView:UIView = UILabel(frame: errVieFrame )
        errView.backgroundColor = UIColor.red
        
        let errLbl:UILabel = UILabel(frame: CGRect.init())
        errLbl.frame.size = CGSize(width: (errView.frame.width) - 50 , height: 40)
        errLbl.center = errView.center
        errLbl.text = "\(ErrMsg)"
        errLbl.textColor = UIColor.white

        UIView.animate(withDuration: 1, animations: {
            errView.transform = CGAffineTransform(translationX: 0, y: -(errView.frame.height))
            errLbl.inputView?.transform = CGAffineTransform(translationX: 0, y: -(errView.frame.height))

            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                errView.transform = CGAffineTransform(translationX: 0, y: (errView.frame.height))
                errLbl.inputView?.transform = CGAffineTransform(translationX: 0, y: (errView.frame.height))
            }
        })
    }
    
    func showLblError(TextField:UITextField,ErrMsg:String){
        TextField.text = ""
        
        let SubView:UIView = UIView.init()
        SubView.frame.size = CGSize(width: TextField.frame.width, height: 5)

        SubView.backgroundColor = UIColor.red
        SubView.layer.shadowRadius = 3
        SubView.layer.shadowOpacity = 0.8
        SubView.layer.shadowOffset = CGSize(width: 5, height: 2)
        SubView.layer.shadowColor = UIColor.red.cgColor
        SubView.clipsToBounds = false
        SubView.center = TextField.center

        let errView:UILabel = UILabel(frame: CGRect.init())
        errView.frame.size = CGSize(width: TextField.frame.width, height: 40)
        errView.text = "*\(ErrMsg)"
        errView.textColor = UIColor.red
       
        TextField.addSubview(errView)
        TextField.addSubview(SubView)

        errView.center = TextField.center
        errView.alpha = 0
        SubView.transform = CGAffineTransform(translationX: 0, y: (TextField.frame.height/2 + 3))
        
        UIView.animate(withDuration: 1, animations: {
            errView.transform = CGAffineTransform(translationX: 0, y: -(TextField.frame.height/2 + 5))
            errView.alpha = 0.8

        })
            
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            UIView.animate(withDuration: 1, animations: {
                errView.alpha = 0
                SubView.alpha = 0
                SubView.frame.size = CGSize(width: 0, height: 5)
            })
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
            errView.removeFromSuperview()
            SubView.removeFromSuperview()
        }
    }
    
    func showLblError2(TextField:UITextField,ErrMsg:String,moveUpBy:CGFloat){
        TextField.text = ""
        
        let SubView:UIView = UIView.init()
        SubView.frame.size = CGSize(width: TextField.frame.width, height: 5)
        
        SubView.backgroundColor = UIColor.red
        SubView.layer.shadowRadius = 3
        SubView.layer.shadowOpacity = 0.8
        SubView.layer.shadowOffset = CGSize(width: 5, height: 2)
        SubView.layer.shadowColor = UIColor.red.cgColor
        SubView.clipsToBounds = false
        SubView.center = TextField.center
        
        let errView:UILabel = UILabel(frame: CGRect.init())
        errView.frame.size = CGSize(width: TextField.frame.width, height: 40)
        errView.text = "*\(ErrMsg)"
        errView.textColor = UIColor.red
        
        TextField.addSubview(errView)
        TextField.addSubview(SubView)
        
        errView.center = TextField.center
        errView.alpha = 0
        SubView.transform = CGAffineTransform(translationX: 0, y: (TextField.frame.height/2 + 3 - moveUpBy) )
        
        UIView.animate(withDuration: 1, animations: {
            errView.transform = CGAffineTransform(translationX: 0, y: -(TextField.frame.height/2 + moveUpBy))
            errView.alpha = 0.8
            
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            UIView.animate(withDuration: 1, animations: {
                errView.alpha = 0
                SubView.alpha = 0
                SubView.frame.size = CGSize(width: 0, height: 5)
            })
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
            errView.removeFromSuperview()
            SubView.removeFromSuperview()
        }
    }
}
