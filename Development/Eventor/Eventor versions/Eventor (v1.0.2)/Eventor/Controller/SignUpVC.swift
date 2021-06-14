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
    
    // Interests View
    let selectedColor:UIColor = UIColor(named: "orangRed3")!
    let unSelectedColr:UIColor = UIColor.lightGray
    
    @IBOutlet weak var intrestsView:UIView!
    var intrestsArry:[String] = []
    @IBOutlet weak var saveBBtn:UIButtonX!
    
    @IBOutlet weak var ABt:UIButtonX!
    @IBOutlet weak var BBt:UIButtonX!
    @IBOutlet weak var CBt:UIButtonX!
    @IBOutlet weak var DBt:UIButtonX!
    @IBOutlet weak var EBt:UIButtonX!
    @IBOutlet weak var FBt:UIButtonX!
    @IBOutlet weak var GBt:UIButtonX!
    @IBOutlet weak var HBt:UIButtonX!
    
    @IBOutlet weak var BDatePicker: UIDatePicker!
    
    @IBOutlet weak var CityPicker: UIPickerView!
    @IBOutlet weak var CityBtn: RoundedBtn!
    var city: String! = "Riyadh"
    let cities = GlobLists.GlobListsObj.Cities
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HindeKeyboardViewTouched()
        ProfileImage.layer.cornerRadius = 100
        ProfileImage.clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpVC.handleSelectProfileProfileImageView))
        ProfileImage.addGestureRecognizer(tapGesture)
        ProfileImage.isUserInteractionEnabled = true
        
        PhoneNbTxt.delegate = self
        PhoneNbTxt.maxLength = 9
        
        CityPicker.dataSource = self
        CityPicker.delegate = self
        
        textFieldsMaxLength()
        
        handleTextField()
        
        let yesterdayDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        BDatePicker.maximumDate = yesterdayDate
        
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldsMaxLength() {
        UserNameTxt.delegate = self
        PhoneNbTxt.delegate = self
        EmailTxt.delegate = self
        PasswordTxt.delegate = self
        ConfPasswordTxt.delegate = self
    }
    
    @IBAction func BDatePicker(_ sender: Any) {
        let d = BDatePicker.date.getDMY().D
        let m = BDatePicker.date.getDMY().M
        let y = BDatePicker.date.getDMY().Y
        
        BDate = date.init(D: d, M: m, Y: y)
    }
    
    @IBAction func addIntrestsBtnPressed(_ sender: Any) {
        view.endEditing(true)
  
        intrestsView.frame = self.view.frame
        intrestsView.center = self.view.center
        updateIntrestsView()
        self.view.addSubview(intrestsView)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case UserNameTxt:
            let maxLength = 40
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            let flag = newString.length <= maxLength
            if !flag{
                notificationHelper.notificationHelperObj.showError(callerVC: self, Err: "cant be more than \(maxLength) digints", color: .orange)
            }
            return flag
        case PhoneNbTxt:
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
        case EmailTxt:
            let maxLength = 60
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            let flag = newString.length <= maxLength
            if !flag{
                notificationHelper.notificationHelperObj.showError(callerVC: self, Err: "cant be more than \(maxLength) digints", color: .orange)
            }
            return flag
        case PasswordTxt:
            let maxLength = 30
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            let flag = newString.length <= maxLength
            if !flag{
                notificationHelper.notificationHelperObj.showError(callerVC: self, Err: "cant be more than \(maxLength) digints", color: .orange)
            }
            return flag
        case ConfPasswordTxt:
            let maxLength = 30
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            let flag = newString.length <= maxLength
            if !flag{
                notificationHelper.notificationHelperObj.showError(callerVC: self, Err: "cant be more than \(maxLength) digints", color: .orange)
            }
            return flag
        default:
            return false
        }
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
            let birthDate: date = BDate {
            
            if username != "" && email != "" && password != "" && confirmPass != "" {
                
                if (password != confirmPass) {
                    ProgressHUD.showError("Passwords do not match")
                } else {
                    //Evntmanger/Admin will NOT! be taken from this view ,so only (NormalUser) info will come through here
                    
                    phoneNb = PhoneNbTxt.text
                    FBDBHandler.FBDBHandlerObj.signUp(uType: userGeneral.getNUStrFormat(), uEmail: email, uPhone: phoneNb, uPassword: password, uStatus: true, name: username, intrests: intrestsArry, address: "", DOB: birthDate, city: Usercity, experians: "", imageData: imageData, onSucces: {
                        
                        
                        ProgressHUD.showSuccess("Success")
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.performSegue(withIdentifier: "tabBarControllerFromSignUp", sender: nil)
                        }
                        
                    }, onError: { error in
                        ProgressHUD.showError(error!)
                    })
                }
                
            }else{
                ProgressHUD.showError("Please fill in all information")
            }
            
           
        } else {
            
            //img error
            if  selectedImage == nil{
                notificationHelper.notificationHelperObj.showError(callerVC: self, Err: "pick a profile image", color: .red)
            }
            ProgressHUD.showError("Please fill in all information")
        }
    }
    
    
    @IBAction func cancelBtbPressed(_ sender: Any) {
        print("canceled ..")
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
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

extension SignUpVC {    
    @IBAction func ABtnPressed(_ sender:UIButtonX){
        self.selectIntrestBtn(Btn:sender)
        
    }
    
    @IBAction func SaveBtnPressed(_ sender:Any){
        handelIntrestsSaveBtn()
        self.intrestsView.removeFromSuperview()
    }
    
    func selectIntrestBtn(Btn:UIButtonX){
        
        UIView.animate(withDuration: 0.3, animations: {
            if Btn.backgroundColor == self.selectedColor {
                Btn.backgroundColor = self.unSelectedColr

                Btn.transform = .identity
                
                
            } else {
                Btn.backgroundColor = self.selectedColor
                Btn.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
            }
        })
    }
    
    func updateIntrestsView(){
        ABt.backgroundColor = unSelectedColr
        BBt.backgroundColor = unSelectedColr
        CBt.backgroundColor = unSelectedColr
        DBt.backgroundColor = unSelectedColr
        EBt.backgroundColor = unSelectedColr
        FBt.backgroundColor = unSelectedColr
        GBt.backgroundColor = unSelectedColr
        HBt.backgroundColor = unSelectedColr
        
        for i in intrestsArry{
            switch i {
            case "Science": selectIntrestBtn(Btn:ABt)
                break;
            case "Computer": selectIntrestBtn(Btn:BBt)
                break;
            case "Comedy": selectIntrestBtn(Btn:CBt)
                break;
            case "Sports": selectIntrestBtn(Btn:DBt)
                break;
            case "Books": selectIntrestBtn(Btn:EBt)
                break;
            case "Food": selectIntrestBtn(Btn:FBt)
                break;
            case "Art": selectIntrestBtn(Btn:GBt)
                break;
            case "Other": selectIntrestBtn(Btn:HBt)
                break;
            default:
                break;
            }
        }
        print("Selected----------------------")
        print(intrestsArry)
    }
    
    func handelIntrestsSaveBtn(){
        intrestsArry = []
        if ABt.backgroundColor == selectedColor{
            intrestsArry.append((ABt.titleLabel?.text)!)
        }
        if BBt.backgroundColor == selectedColor{
            intrestsArry.append((BBt.titleLabel?.text)!)
        }
        if CBt.backgroundColor == selectedColor{
            intrestsArry.append((CBt.titleLabel?.text)!)
        }
        if DBt.backgroundColor == selectedColor{
            intrestsArry.append((DBt.titleLabel?.text)!)
        }
        if EBt.backgroundColor == selectedColor{
            intrestsArry.append((EBt.titleLabel?.text)!)
        }
        if FBt.backgroundColor == selectedColor{
            intrestsArry.append((FBt.titleLabel?.text)!)
        }
        if GBt.backgroundColor == selectedColor{
            intrestsArry.append((GBt.titleLabel?.text)!)
        }
        if HBt.backgroundColor == selectedColor{
            intrestsArry.append((HBt.titleLabel?.text)!)
        }
    }
}


