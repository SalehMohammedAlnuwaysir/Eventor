//
//  startVC.swift
//  Eventor
//
//  Created by YAZEED NASSER on 03/04/2019.
//  Copyright © 2019 Eventor. All rights reserved.
//

import UIKit
import Firebase

class startVC: UIViewController {

    @IBOutlet weak var theView:UIView!
    @IBOutlet weak var orLbl:UILabel!
    @IBOutlet weak var infoLbbl:UILabel!
    @IBOutlet weak var reloadBtn:UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        HindeKeyboardViewTouched()
        theView.clipsToBounds = true
        startPricess()
        
        
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
    }
    
    func startPricess(){
        self.startAni()
        reloadBtn.isHidden = true
        
        FBDBHandler.FBDBHandlerObj.loadFBAppVersion(onSucces: {
            if let currAppVer = UIApplication.appVersion{
                if Double(FBDBHandler.FBAppVer)! <= Double(currAppVer)!{
                    self.logingIn()
                } else {
                    //show Error :(update to the new app version)
                    self.endAni()
                    self.infoLbbl.text = "the Current app version is old\n update the app to slove this problem"
                }
            }
        }, onError: {
            self.infoLbbl.text = "hhhh"
            self.endAni()
            //show error with the app

        })
    }
    
    func logingIn(){
        if FBDBHandler.FBDBHandlerObj.checkInternet(){
            if Auth.auth().currentUser != nil{ //logged in
                infoLbbl.text = "Logging in..."
                
                FBDBHandler.FBDBHandlerObj.loadMyUser(UID: (Auth.auth().currentUser?.uid)!, onSucces: {
                    FBDBHandler.FBDBHandlerObj.signIn(email: currnetUser.uEmail, password: currnetUser.uPassword, onSucces: {
                        self.endAni()
                        if currnetUser.uType == userGeneral.getNUStrFormat(){
                            self.infoLbbl.text = "Hi \((currnetUser as! normalUser).name!) "
                            
                        }else if currnetUser.uType == userGeneral.getEMStrFormat(){
                            self.infoLbbl.text = "Hi \((currnetUser as! eventManager).name!) "
                        }else if currnetUser.uType == userGeneral.getAdminStrFormat(){
                            self.infoLbbl.text = "Preparing for Admin Page..."

                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            
                            if currnetUser.uType == userGeneral.getAdminStrFormat(){
                                self.infoLbbl.text = "Loading events info..."
                                FBDBHandler.FBDBHandlerObj.loadEves(onSucces: {
                                    self.infoLbbl.text = "Loading users info..."
                                    FBDBHandler.FBDBHandlerObj.loadUsers(onSucces: {
                                        self.performSegue(withIdentifier: "adminVC", sender: nil)
                                    }, onError: {_ in
                                        self.infoLbbl.text = "! couldn't load users"

                                    })
                                }, onError: {_ in
                                    self.infoLbbl.text = "! couldn't load event"

                                })
                            }else{
                                self.performSegue(withIdentifier: "logedIn", sender: nil)
                            }
                            
                        }
                    }, onError: {_ in
                        self.infoLbbl.text = "Sorry! it seems somthing went wrong!"
                        self.reloadBtn.isHidden = false
                        
                    })
                })
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 30.0) {
                    self.infoLbbl.text = "\(self.infoLbbl.text!) \nit seems your connection is slow \nor maybe an error happend!,"
                    self.reloadBtn.isHidden = false
                }
                
                
            }else{//not logged in
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    self.performSegue(withIdentifier: "notLogedIn", sender: nil)
                    
                    self.endAni()
                    
                }
            }
            //end checking (loging)
        } else {
            infoLbbl.text = "Check your connection!"
            reloadBtn.isHidden = false
        }
    }
    
    func startAni(){
        let Viewhight = theView.frame.height / 2
        UIView.animate(withDuration: 2.0, animations: {
            
            self.theView.layer.cornerRadius = Viewhight
            //self.theView.transform = CGAffineTransform(rotationAngle: 100)
            self.orLbl.transform = CGAffineTransform(translationX: -(self.orLbl.frame.width)*4, y: 0)
            self.orLbl.alpha = 0
        })
        
        //loop
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {

            UIView.animate(withDuration: 0.5, delay: 0.1, options: [.repeat, .autoreverse], animations: {
                self.theView.transform = CGAffineTransform(rotationAngle: 50)
                self.theView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                self.theView.center = self.view.center

            }, completion: { (finished: Bool) -> Void in
                
            })
        }
    }
    
    func endAni(){
        UIView.animate(withDuration: 0.5, animations: {
            self.orLbl.alpha = 1
            self.theView.transform = .identity
            self.orLbl.transform = .identity
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.theView.layer.removeAllAnimations()
        }
    }
    
    @IBAction func reloadBtnPressed(_ sender:Any){
        //logingIn()
        startPricess()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destnation = segue.destination as? AdminVC {
           destnation.startVC = self
        }
    }
}

extension UIApplication {
    static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
}
