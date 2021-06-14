//
//  SignInVC.swift
//  Eventor
//
//  Created by Saleh on 19/05/1440 AH.
//  Copyright © 1440 Eventor. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SignInVC: UIViewController {
    @IBOutlet weak var EmailTxt: UITextField!
    @IBOutlet weak var PasswordTxt: UITextField!
    @IBOutlet weak var BGImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HindeKeyboardViewTouched()
        
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (Auth.auth().currentUser != nil) {
            FBDBHandler.FBDBHandlerObj.loadMyUser(UID: (Auth.auth().currentUser?.uid)! , onSucces: {
                self.performSegue(withIdentifier: "tabBarController", sender: nil)
            })
        }
    }
    
    @IBAction func SignInBtnPressed(_ sender: Any) {        
        if (EmailTxt.text == "" || PasswordTxt.text == "") {
            ProgressHUD.showError("Please fill in all information")
        } else {
            view.endEditing(true)
            refrishingHanler.refrishingHanlerObj.startRefrising(view: self.view)

            FBDBHandler.FBDBHandlerObj.signIn(email: EmailTxt.text!, password: PasswordTxt.text!, onSucces: {
                refrishingHanler.refrishingHanlerObj.endRefrising(view: self.view)
                ProgressHUD.showSuccess("Log-In Success")
                
                self.EmailTxt.text = ""
                self.PasswordTxt.text = ""

                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    
                    
                    if currnetUser.uType == userGeneral.getAdminStrFormat(){
                       
                        FBDBHandler.FBDBHandlerObj.loadEves(onSucces: {
                            FBDBHandler.FBDBHandlerObj.loadUsers(onSucces: {
                                self.performSegue(withIdentifier: "adminVC", sender: nil)
                            }, onError: {_ in})
                        }, onError: {_ in})
                    }else{
                        self.performSegue(withIdentifier: "tabBarController", sender: nil)
                    }
                    
                }
            }, onError: { error in
                refrishingHanler.refrishingHanlerObj.endRefrising(view: self.view)
                ProgressHUD.showError(error!)
            })
        }
    }
    @IBAction func cancelBtnPressed(_ sender: Any) {
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        dismiss(animated: true, completion: nil)
    }
}
