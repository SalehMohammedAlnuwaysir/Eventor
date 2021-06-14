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

    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var organizationName: UITextField!
    @IBOutlet weak var EmailTxt: UITextField!
    @IBOutlet weak var PasswordTxt: UITextField!
    @IBOutlet weak var ConfPasswordTxt: UITextField!
    @IBOutlet var submetView: UIView!
    @IBOutlet weak var cityPick: UIPickerView!
    @IBOutlet weak var cityPickBtn: RoundedBtn!
    @IBOutlet weak var addressTxt: UITextField!
    @IBOutlet weak var phoneTxt: UITextField!
    
     var selectedImage: UIImage?
    
    var city: String! = "Riyadh"
    let cities = GlobLists.GlobListsObj.Cities
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HindeKeyboardViewTouched()
        cityPick.dataSource = self
        cityPick.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpVC.handleSelectProfileProfileImageView))
        ProfileImage.addGestureRecognizer(tapGesture)
        ProfileImage.isUserInteractionEnabled = true
        
        phoneTxt.delegate = self
        phoneTxt.maxLength = 9
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func handleSelectProfileProfileImageView() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func submetBtnPressed(_ sender: Any) {
        if self.chekUserInput() {
            if let profileImageStorage = self.selectedImage,
                let imageData = UIImageJPEGRepresentation(profileImageStorage, 0.8),
                let orgName:String = organizationName.text,
                let email:String = EmailTxt.text,
                let pass:String = PasswordTxt.text,
                let confPass:String = ConfPasswordTxt.text,
                let city:String = city,
                let address:String = addressTxt.text,
                let phone:String = phoneTxt.text
            {
                view.endEditing(true)
                ProgressHUD.show("", interaction: false)

                let uType:String = userGeneral.getEMStrFormat()
                let EMUserObj:eventManager = eventManager.init(UID: "", picURL: "", uType: uType, uEmail: email, uPhone: phone, uPassword: pass, uStatus: false, name: orgName, address: address, MyEvents: [], city: city,MyNotifcation:[])
                    
                    
                FBDBHandler.FBDBHandlerObj.ReqEveManagerAcc(EMUserObj: EMUserObj, imageData: imageData, onSucces: {
                        ProgressHUD.showSuccess("Success")
                        
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.submetView.frame.size = self.view.frame.size
                        self.view.addSubview(self.submetView)
                        self.submetView.center = self.view.center
                    }
                }, onError: { error in
                        ProgressHUD.showError(error!)
                })
            } else {
                if selectedImage == nil {
                    notificationHelper.notificationHelperObj.showError(callerVC: self, Err: "Pick a profile image", color: .red)
                }
            } // end if-let
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
            
            if checkInputToShowError(orgName:orgName , email:email, pass:pass , confPass:confPass , address :address, phone:phone) {
                return true
            }
            return false
       } else {
            ProgressHUD.showError("Fill all info!")
            return false
        }
    }
    
    func checkInputToShowError(orgName:String , email:String, pass:String , confPass:String , address :String, phone:String) -> Bool{
        var flag = true
        
        if !checkPassandComfermPass(pass: pass, confPass: confPass){
            flag = false
        }
        
        if orgName == "" {
            flag = false
            ErrorHndeler.ErrorHndelerObj.showLblError(TextField: organizationName, ErrMsg: "Shuold not be empty!")
        }
        
        if email == "" {
            flag = false
            ErrorHndeler.ErrorHndelerObj.showLblError(TextField: EmailTxt, ErrMsg: "Shuold not be empty!")
        }
        
        if phone == "" || phone.count < 9{
            flag = false
            ErrorHndeler.ErrorHndelerObj.showLblError(TextField: phoneTxt, ErrMsg: "Shuold not be empty or < 9 digits!")
        }
        
        if address == "" {
            flag = false
            ErrorHndeler.ErrorHndelerObj.showLblError(TextField: addressTxt, ErrMsg: "Shuold not be empty!")
        }
        
        return flag
    }
    
    func checkPassandComfermPass(pass:String , confPass:String)-> Bool{
        var flag = true
        if pass == "" || confPass == "" {
            flag = false
            ErrorHndeler.ErrorHndelerObj.showLblError(TextField: PasswordTxt, ErrMsg: "Shuold not be empty!")
            ErrorHndeler.ErrorHndelerObj.showLblError(TextField: ConfPasswordTxt, ErrMsg: "")

        }
        else if pass != confPass {
            flag = false
            ErrorHndeler.ErrorHndelerObj.showLblError(TextField: PasswordTxt, ErrMsg: "Do not match!")
            ErrorHndeler.ErrorHndelerObj.showLblError(TextField: ConfPasswordTxt, ErrMsg: "")
        }else if pass.count < 6{
            flag = false
            ErrorHndeler.ErrorHndelerObj.showLblError(TextField: PasswordTxt, ErrMsg: "Shuold be 6 >= digits")
            ErrorHndeler.ErrorHndelerObj.showLblError(TextField: ConfPasswordTxt, ErrMsg: "")
        }
        
        return flag
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
}

extension RequestEMAccountVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("Picked a photo")
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = image
            ProfileImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}


