//
//  WelcomeVC.swift
//  Eventor
//
//  Created by Saleh on 19/05/1440 AH.
//  Copyright © 1440 Eventor. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {

    @IBOutlet weak var signInBtn: UIButtonX!
    @IBOutlet weak var signUpBtn: UIButtonX!
    @IBOutlet weak var requestEMABtn: UIButton!
    var canClick: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        canClick = true
        
        checkLanguage()
        
        HindeKeyboardViewTouched()
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        UIApplication.shared.statusBarView?.backgroundColor = hexStringToUIColor("#fe5427")
    }
    
    func checkLanguage() {
        let signInTitle = NSLocalizedString("SignIn", comment: "")
        let signUpTitle = NSLocalizedString("SignUp", comment: "")
        let REMTitle = NSLocalizedString("RequestEMAccount", comment: "")
        self.signInBtn.setTitle(signInTitle,for: .normal)
        self.signUpBtn.setTitle(signUpTitle,for: .normal)
        self.requestEMABtn.setTitle(REMTitle,for: .normal)
        //UIView.appearance().semanticContentAttribute = .forceLeftToRight
    }
    
    @IBAction func start(_ sender: Any) {
        if (!canClick) {
            print("can't click")
            butttonDisabledAlert(title: "Button is disabled!", message: "You can send only one request, try again after 12 hours")
        } else {
            canClick = false
            self.performSegue(withIdentifier: "requestEMAccountSG", sender: nil)
            Timer.scheduledTimer(timeInterval: 12 * 60 * 60, target: self, selector: #selector(enableButton), userInfo: nil, repeats: false)
        }
    }
    
    @objc func enableButton() {
        canClick = true
    }
    
    func butttonDisabledAlert(title: String, message: String) {
        print("aleeert")
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
