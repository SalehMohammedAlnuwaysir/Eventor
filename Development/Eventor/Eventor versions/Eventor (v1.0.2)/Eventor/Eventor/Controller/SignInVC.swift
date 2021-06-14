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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        //        let instanceAuthService = AuthSevice()
        //        instanceAuthService.signIn()
        
        //        AuthSevice.shared.signIn()
        
        if (EmailTxt.text == "" || PasswordTxt.text == "") {
            ProgressHUD.showError("Please fill in all information")
        } else {
            view.endEditing(true)
            ProgressHUD.show("", interaction: false)
            
            FBDBHandler.FBDBHandlerObj.signIn(email: EmailTxt.text!, password: PasswordTxt.text!, onSucces: {
                ProgressHUD.showSuccess("Success")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.performSegue(withIdentifier: "tabBarController", sender: nil)
                }
            }, onError: { error in
            ProgressHUD.showError(error!)
            })
        }
    }
    @IBAction func cancelBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
