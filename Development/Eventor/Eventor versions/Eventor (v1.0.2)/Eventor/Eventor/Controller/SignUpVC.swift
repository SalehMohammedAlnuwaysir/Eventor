//
//  SignUpVC.swift
//  Eventor
//
//  Created by Saleh on 19/05/1440 AH.
//  Copyright © 1440 Eventor. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class SignUpVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var UserNameLbl: UILabel!
    @IBOutlet weak var UserNameTxt: UITextField!
    @IBOutlet weak var DateLbl: UILabel!
    @IBOutlet weak var EmailLbl: UILabel!
    @IBOutlet weak var EmailTxt: UITextField!
    @IBOutlet weak var PasswordTxt: UITextField!
    @IBOutlet weak var ConfPasswordTxt: UITextField!
    @IBOutlet weak var SubmrtBtn: RoundedBtn!
    @IBOutlet weak var CancelBtn: RoundedBtn!
    @IBOutlet weak var SignInBtn: UIButton!
    
    @IBOutlet weak var PhoneNbLbl: UILabel!
    @IBOutlet weak var PhStartLbl: UILabel!
    @IBOutlet weak var PhoneNbTxt: UITextField!
    
    var BDate:date! = nil
    
    var phoneNb: String! = ""
    
    var selectedImage: UIImage?

    @IBOutlet weak var BDatePicker: UIDatePicker!
    
    @IBOutlet weak var CityPicker: UIPickerView!
    @IBOutlet weak var CityBtn: RoundedBtn!
    var city: String! = "Riyadh"
    let cities = GlobLists.GlobListsObj.Cities
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProfileImage.layer.cornerRadius = 100
        ProfileImage.clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpVC.handleSelectProfileProfileImageView))
        ProfileImage.addGestureRecognizer(tapGesture)
        ProfileImage.isUserInteractionEnabled = true
        
        PhoneNbTxt.delegate = self
        PhoneNbTxt.maxLength = 9
        
        CityPicker.dataSource = self
        CityPicker.delegate = self
        
        handleTextField()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func BDatePicker(_ sender: Any) {
        let d = BDatePicker.date.getDMY().D
        let m = BDatePicker.date.getDMY().M
        let y = BDatePicker.date.getDMY().Y
        
        BDate = date.init(D: d, M: m, Y: y)
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
    
    func handleTextField() {
        UserNameTxt.addTarget(self, action: #selector(SignUpVC.textFieldChanged), for: UIControlEvents.editingChanged)
        EmailTxt.addTarget(self, action: #selector(SignUpVC.textFieldChanged), for: UIControlEvents.editingChanged)
        PasswordTxt.addTarget(self, action: #selector(SignUpVC.textFieldChanged), for: UIControlEvents.editingChanged)
        ConfPasswordTxt.addTarget(self, action: #selector(SignUpVC.textFieldChanged), for: UIControlEvents.editingChanged)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func textFieldChanged() {
    }
    
    @objc func handleSelectProfileProfileImageView() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func dismissToSignIn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func citiesBtnPressed(_ sender: Any) {
        CityBtn.isHidden = true
        CityPicker.isHidden  = false
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView == CityPicker) {
            let titleRow = cities[row]
            return titleRow
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var toRet : Int = self.cities.count
        if (pickerView == CityPicker){
            toRet = self.cities.count
        }
        return toRet
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //ChooseCHCategory.text = CHCategory[row]
        if (pickerView == CityPicker) {
            CityBtn.setTitle(String(cities[row]), for: UIControlState.normal)
            CityBtn.isHidden = false
            CityPicker.isHidden = true
        }
        city = String(cities[row])
        print(city)
    }
    
    
    @IBAction func sumbetBtnPressed(_ sender: Any) {
        view.endEditing(true)
        ProgressHUD.show("", interaction: false)
        if let profileImageStorage = self.selectedImage,
            let imageData = UIImageJPEGRepresentation(profileImageStorage, 0.8),
            let username = UserNameTxt.text,
            let email = EmailTxt.text,
            let password: String = PasswordTxt.text,
            let confirmPass: String = ConfPasswordTxt.text,
            let Usercity = city,
            let birthDate: date = BDate
        {
            if (password != confirmPass) {
                ProgressHUD.showError("Passwords do not match")
            } else {
                //Evntmanger/Admin will NOT! be taken from this view ,so only (NormalUser) info will come through here
                
                phoneNb = PhoneNbTxt.text
                FBDBHandler.FBDBHandlerObj.signUp(uType: userGeneral.getNUStrFormat(), uEmail: email, uPhone: phoneNb, uPassword: password, uStatus: true, name: username, address: "", DOB: birthDate, city: Usercity, experians: "", imageData: imageData, onSucces:{

                
                    ProgressHUD.showSuccess("Success")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.performSegue(withIdentifier: "tabBarControllerFromSignUp", sender: nil)
                    }
                    
                }, onError: { error in
                    ProgressHUD.showError(error!)
                })
            }
        } else {
            ProgressHUD.showError("Please fill in all information")
        }
    }
    
    @IBAction func cancelBtbPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension SignUpVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("Picked a photo")
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = image
            ProfileImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}


extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            return 5
        }
        set {
            
        }
    }
}
