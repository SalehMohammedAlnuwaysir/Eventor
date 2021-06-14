//
//  RequestEMAccountVC.swift
//  Eventor
//
//  Created by Saleh on 19/05/1440 AH.
//  Copyright © 1440 Eventor. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RequestEMAccountVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
   
    
    
    @IBOutlet weak var organizationName: UITextField!
    @IBOutlet weak var EmailTxt: UITextField!
    @IBOutlet weak var PasswordTxt: UITextField!
    @IBOutlet weak var ConfPasswordTxt: UITextField!
    @IBOutlet var submetView: UIView!
    @IBOutlet weak var cityPick: UIPickerView!
    @IBOutlet weak var cityPickBtn: RoundedBtn!
    @IBOutlet weak var addressTxt: UITextField!
    @IBOutlet weak var phoneTxt: UITextField!
    var city: String! = "Riyadh"
    let cities = GlobLists.GlobListsObj.Cities
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityPick.dataSource = self
        cityPick.delegate = self
        
        phoneTxt.delegate = self
        phoneTxt.maxLength = 9
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submetBtnPressed(_ sender: Any) {
       
        if self.chekUserInput(){
            
            if let orgName:String = organizationName.text,
                let email:String = EmailTxt.text,
                let pass:String = PasswordTxt.text,
                let confPass:String = ConfPasswordTxt.text,
                let city:String = city,
                let address:String = addressTxt.text,
                let phone:String = phoneTxt.text,
                let profileImg = UIImage.init(named: "Profile-photo"),
                let defultProileImageData = UIImageJPEGRepresentation(profileImg, 0.8)
            {
                view.endEditing(true)
                ProgressHUD.show("", interaction: false)
                

                    let uType:String = userGeneral.getEMStrFormat()
                    let EMUserObj:eventManager = eventManager.init(UID: "", picURL: "", uType: uType, uEmail: email, uPhone: phone, uPassword: pass, uStatus: false, name: orgName, address: address, MyEvents: [], city: city)
               
                
                    FBDBHandler.FBDBHandlerObj.ReqEveManagerAcc(EMUserObj: EMUserObj, imageData: defultProileImageData, onSucces: {
                        ProgressHUD.showSuccess("Success")

                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.submetView.frame.size = self.view.frame.size
                            self.view.addSubview(self.submetView)
                            self.submetView.center = self.view.center
                        }
                    }, onError: { error in
                        ProgressHUD.showError(error!)
                    })
                
            }//end if-let
            
        }
       
    }
    
    func chekUserInput()->Bool{
        
        
        if  let orgName:String = organizationName.text,
            let email:String = EmailTxt.text,
            let pass:String = PasswordTxt.text,
            let confPass:String = ConfPasswordTxt.text,
            let city:String = city,
            let address:String = addressTxt.text,
            let phone:String = phoneTxt.text{
            
            if orgName != "" && email != "" && pass != "" && confPass != "" && address != "", phone != ""{
                
                if pass != confPass {
                    ProgressHUD.showError("passWord doesn't match!")
                    return false
                }else if pass.count < 6{
                    ProgressHUD.showError("passWord shuld be more tha 6 charchtors!")
                    return false
                }
                
                return true

            }else{
                ProgressHUD.showError("Fill all info!")
                return false
            }
            return true
       }else{
            ProgressHUD.showError("Fill all info!")
            return false
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 9
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        let allowedCharecters = "0123456789"
        let allowedCharectersSet = CharacterSet(charactersIn: allowedCharecters)
        let typedCharectersSet = CharacterSet(charactersIn: string)
        
        if textField.text?.count == 0 && string != "5"{
            return false
        }
        return allowedCharectersSet.isSuperset(of: typedCharectersSet)  && newString.length <= maxLength
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func okBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func cityBtnPressed(_ sender: Any) {
        cityPickBtn.isHidden = true
        cityPick.isHidden  = false
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView == cityPick) {
            let titleRow = cities[row]
            return titleRow
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var toRet : Int = self.cities.count
        if (pickerView == cityPick){
            toRet = self.cities.count
        }
        return toRet
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //ChooseCHCategory.text = CHCategory[row]
        if (pickerView == cityPick) {
            cityPickBtn.setTitle(String(cities[row]), for: UIControlState.normal)
            cityPickBtn.isHidden = false
            cityPick.isHidden = true
        }
        city = String(cities[row])
        print(city)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
