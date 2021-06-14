//
//  ProfileVC.swift
//  Eventor
//
//  Created by Saleh on 19/05/1440 AH.
//  Copyright © 1440 Eventor. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileVC: UIViewController {
    var isMenuShowed: Bool!
    
    @IBOutlet weak var profileImgView: UIImageView!
    //labels
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var DOBLbl: UILabel!
    
    //volunteer stars
    @IBOutlet weak var theWholeStarsAndLblView: UIViewX!
    @IBOutlet weak var theWholeStarsView: UIView!
    @IBOutlet weak var starsLbl: UILabel!
    @IBOutlet weak var starNo1: UIImageView!
    @IBOutlet weak var starNo2: UIImageView!
    @IBOutlet weak var starNo3: UIImageView!
    @IBOutlet weak var starNo4: UIImageView!
    @IBOutlet weak var starNo5: UIImageView!
    
    //buttons
    var whatBtnPressed = ""
    @IBOutlet weak var myEvesBtn: UIButtonX!
    @IBOutlet weak var eveToVolBtn: UIButton!
    @IBOutlet weak var eveToSponsorBtn: UIButton!
    @IBOutlet weak var joinedEveBtn: UIButton!
    @IBOutlet weak var subscribedEveBtn: UIButton!
    
    // Backgroudn view For popup Views
    let BGPopupView:UIView = UIView.init(frame: CGRect.init())
    
    //editPforfile View
    @IBOutlet var editProfileView: UIViewX!
    @IBOutlet weak var EPCloseBtn: RoundedBtn!
    @IBOutlet weak var EPImgView: UIImageViewX!
    var selectedImage: UIImage?
    @IBOutlet weak var EPNameTxt: UITextField!
    @IBOutlet weak var addIntestsBtn:UIButton!
    var intrestsArr:[String] = []
    @IBOutlet weak var phoneNum:UILabel!
    @IBOutlet weak var phoneNumTxt:UITextField!
    @IBOutlet weak var EPSaveBtn: RoundedBtn!
    
    
    //changePass View
    @IBOutlet var changePassView: UIViewX!
    @IBOutlet weak var CPCloseBtn: RoundedBtn!
    @IBOutlet weak var CPPassTxt: UITextField!
    @IBOutlet weak var CPComfPassTxt: UITextField!
    @IBOutlet weak var CPSaveBtn: RoundedBtn!
    
    //addExpb View
    @IBOutlet weak var addExp_View:UIView!
    @IBOutlet weak var AE_CloseBtn:UIButton!
    @IBOutlet weak var AE_ExpDescTxt:UITextView!
    

    //improveToEM View
    @IBOutlet weak var improveToEM_View:UIView!
    @IBOutlet weak var ITEM_CloseBtn:UIButton!
    @IBOutlet weak var ITEM_OrgNameTxt:UITextField!
    @IBOutlet weak var ITEM_OrgAddressTxt:UITextField!
    @IBOutlet weak var ITEM_ResoneTxt:UITextView!
    
    //menue
    @IBOutlet weak var menuView:UIView!
    @IBOutlet weak var CurveImageView:UIImageView!
    @IBOutlet weak var screenCoverdBtn:UIButton!
    @IBOutlet weak var menuBtnsView:UIView!
    @IBOutlet weak var editProfilebtn:UIButton!
    @IBOutlet weak var changePassbtn:UIButton!
    @IBOutlet weak var addExpbtn:UIButton!
    @IBOutlet weak var reqSponsorbtn:UIButton!
    @IBOutlet weak var improveToEMbtn:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        HindeKeyboardViewTouched()
        
        hideMenu()
        phoneNumTxt.delegate = self
        EPNameTxt.delegate = self
        ITEM_OrgNameTxt.delegate = self
        isMenuShowed = false
        
        print(Auth.auth().currentUser!.uid)
        // Do any additional setup after loading the view.
        self.updateView()
        self.postionView()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpVC.handleSelectProfileProfileImageView))
        EPImgView.addGestureRecognizer(tapGesture)
        EPImgView.isUserInteractionEnabled = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hideMenu() {
        UIView.animate(withDuration: 0.5, animations: {
            self.menuView.alpha = 0
            self.screenCoverdBtn.alpha = 0
        })
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.menuBtnsView.alpha = 0
            self.menuBtnsView.transform = CGAffineTransform(translationX: self.view.frame.width, y: 0)
            self.CurveImageView.transform = CGAffineTransform(translationX: self.CurveImageView.frame.width, y: 0)
        })
    }
    
    func showMenue() {
        UIView.animate(withDuration: 0.5, animations: {
            self.menuView.alpha = 0.95
            self.screenCoverdBtn.alpha = 0.5
        })
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.CurveImageView.transform = .identity //the default value
            self.menuBtnsView.transform = .identity //the default value
            self.menuBtnsView.alpha = 0.9
        })
    }
    
    @IBAction func menuBtnPressed(_ sender: Any) {
        if (isMenuShowed) {
            hideMenu()
            isMenuShowed = false
        } else {
            showMenue()
            isMenuShowed = true
        }
    }
    
    @IBAction func DarkViewTapped(_ sender: Any) {
        hideMenu()
        isMenuShowed = false
        
    }
    
    
    //acctions
    func postionView(){
        let superViewFrame = self.view.frame
        let superViewCenter = self.view.center
        BGPopupView.frame = superViewFrame
        BGPopupView.center = superViewCenter
        BGPopupView.backgroundColor = UIColor.white
        
        editProfileView.center = superViewCenter
        changePassView.center = superViewCenter
        addExp_View.center = superViewCenter
//        reqSponsor_View.center = superViewCenter
        improveToEM_View.center = superViewCenter
    }
    
    @IBAction func logoutBtnPressed(_ sender: Any) {
        logoutBtnPressedAlert(title: "Are you sure you want to sign out?", message: "")
    }

    func logoutBtnPressedAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.destructive, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            print ("No")
        }))
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            do {
                try Auth.auth().signOut()
            } catch let logoutError {
                print (logoutError)
            }
            let Storyboard = UIStoryboard(name: "Main", bundle: nil)
            let WelcomeVC = Storyboard.instantiateViewController(withIdentifier: "WelcomeVC")
            self.present(WelcomeVC, animated: true, completion: nil)
            print("Yes")
        }))
        self.present(alert, animated: true, completion: nil)
    }

    
    @IBAction func eveToVolBtnPressed(_ sender: Any) {
        whatBtnPressed = "eveToVol"
        let  VolInEvents:[Event] = Event.getEvesToVolInList()
        self.performSegue(withIdentifier: "showEvntsListVC", sender: VolInEvents)

    }
    
    @IBAction func eveToSponsorBtnPressed(_ sender: Any) {
        whatBtnPressed = "eveToSponsor"

        let  EventsToSponsor:[Event] = allEventsToSponsorGlobalArry
        self.performSegue(withIdentifier: "showEvntsListVC", sender: EventsToSponsor)
        
    }
    
    @IBAction func joinedEveBtnPressed(_ sender: Any) {
        whatBtnPressed = "joinedEve"

        FBDBHandler.FBDBHandlerObj.loadEventsUserVoledIn(UID: currnetUser.UID, completion: {

            if let VoledEventIds:[String] =  (currnetUser as! normalUser).getVolEveIds() {
                let  VoledEvents:[Event] = Event.getEveListByIDsFromGolbEveArry(EIDs: VoledEventIds)
                self.performSegue(withIdentifier: "showEvntsListVC", sender: VoledEvents)
            }
        })
    }
    
    @IBAction func subscribedEveBtnPressed(_ sender: Any) {
        whatBtnPressed = "subscribedEve"

        FBDBHandler.FBDBHandlerObj.loadIdOfSubscribedEvents(UID: currnetUser.UID, completion: {
            if let SubEventIds:[String] =  (currnetUser as! normalUser).subEvents {
                let  SubEvents:[Event] = Event.getEveListByIDsFromGolbEveArry(EIDs: SubEventIds)
                self.performSegue(withIdentifier: "showEvntsListVC", sender: SubEvents)
            }
        })
    }
    

    
    @IBAction func myEveBtnPressed(_ sender: Any){
        whatBtnPressed = "myEve"

        refrishingHanler.refrishingHanlerObj.startRefrising(view: self.view)
        FBDBHandler.FBDBHandlerObj.loadMyEventsID(UID: currnetUser.UID, completion: {
            refrishingHanler.refrishingHanlerObj.endRefrising(view: self.view)

            if let MyEventIds:[String] =  (currnetUser as! eventManager).MyEvents {
                let  MyEvents:[Event] = Event.getEveListByIDsFromGolbEveArry(EIDs: MyEventIds)
                
                self.performSegue(withIdentifier: "showEvntsListVC", sender: MyEvents)
            }
        })
    }
    
    
    func updateView(){
        //prepare
        DOBLbl.isHidden = true
        myEvesBtn.isHidden = true
        eveToVolBtn.isHidden = true
        eveToSponsorBtn.isHidden = true
        joinedEveBtn.isHidden = true
        subscribedEveBtn.isHidden = true
        theWholeStarsAndLblView.isHidden = true
        
        editProfilebtn.isHidden = true
        changePassbtn.isHidden = true
        addExpbtn.isHidden = true
        reqSponsorbtn.isHidden = true
        improveToEMbtn.isHidden = true


        
        
        //updating the view acording to the user type
        if currnetUser.uType == userGeneral.getAdminStrFormat(){
            self.updateViewForAdmin()
        }
        else if currnetUser.uType == userGeneral.getEMStrFormat(){
            self.updateViewForEM()
        }
        else if currnetUser.uType == userGeneral.getNUStrFormat(){
            self.updateViewForNU()
        }
        
    }
    func updateViewForAdmin(){//admin View
        changePassbtn.isHidden = false

    }
    func updateViewForEM(){//event manager View
        let profileImgURL:String = (currnetUser as! eventManager).picURL
        FBDBHandler.FBDBHandlerObj.getImageBy(URL: profileImgURL, imageViewToLoadOn: profileImgView)
        nameLbl.text = (currnetUser as! eventManager).name
        
        eveToSponsorBtn.isHidden = false
        myEvesBtn.isHidden = false
        
        editProfilebtn.isHidden = false
        changePassbtn.isHidden = false
    }
    
    func updateViewForNU(){//normal user View
        
        let profileImgURL:String = (currnetUser as! normalUser).picURL
        FBDBHandler.FBDBHandlerObj.getImageBy(URL: profileImgURL, imageViewToLoadOn: profileImgView)
        
        if let name = (currnetUser as! normalUser).name,
            let DOB = (currnetUser as! normalUser).DOB,
            let didVol = (currnetUser as! normalUser).didVol{
           
                self.updateToViewForVol(didVol:didVol)

                nameLbl.text = name
                DOBLbl.text = DOB.getDateFormatAsString()
            
                DOBLbl.isHidden = false
                subscribedEveBtn.isHidden = false
            
            editProfilebtn.isHidden = false
            changePassbtn.isHidden = false
            reqSponsorbtn.isHidden = false
            improveToEMbtn.isHidden = false
            
            //showing stars
            self.showAndUpdateVolStars()

        }
    }
    
    func updateToViewForVol(didVol:Bool){//volunteer View
        if didVol {
            self.joinedEveBtn.isHidden = false
            eveToVolBtn.isHidden = false
            self.subscribedEveBtn.isHidden = false
            self.theWholeStarsAndLblView.isHidden = false
            
            addExpbtn.isHidden = false
        }
    }
    
    func addPopupView(pupupView:UIView){
        BGPopupView.alpha = 0
        pupupView.alpha = 0
        
        self.view.addSubview(BGPopupView)
        self.view.addSubview(pupupView)
        pupupView.transform = CGAffineTransform(translationX: 0, y: 30)

        UIView.animate(withDuration: 0.3 , animations: {
            if pupupView == self.changePassView{
                pupupView.transform = CGAffineTransform(translationX: 0, y: -70)

            } else {
                pupupView.transform = .identity
            }
            self.BGPopupView.alpha = 0.8
            pupupView.alpha = 1
        })
    }
    
    func removePopupView(pupupView:UIView,Comp: @escaping  ()->(Void)){
        UIView.animate(withDuration: 0.2 , animations: {
            pupupView.transform = CGAffineTransform(translationX: 0, y: -20)
            self.BGPopupView.alpha = 0
            pupupView.alpha = 0
            
        }, completion: { isCompleted in
            if isCompleted{
                pupupView.removeFromSuperview()
                self.BGPopupView.removeFromSuperview()
                Comp()
            }
        })
    }
    
    // Menu actions
    @IBAction func EditProfileBtnPressed(_ sender: Any) {
        self.menuBtnPressed(self) //to hide menu
        
        self.updateEditProfileView()
        self.addPopupView(pupupView: self.editProfileView)
    }
    
    func updateEditProfileView(){
        //prepare
        addIntestsBtn.isHidden = true

        if currnetUser.uType == userGeneral.getEMStrFormat(){
            let userObj = (currnetUser as! eventManager)
            EPImgView.image = profileImgView.image
            self.EPNameTxt.text = userObj.name
            self.phoneNumTxt.text = userObj.uPhone
            
        }else if currnetUser.uType == userGeneral.getNUStrFormat(){
            addIntestsBtn.isHidden = false


            let userObj = (currnetUser as! normalUser)
            EPImgView.image = profileImgView.image
            self.EPNameTxt.text = userObj.name
            self.phoneNumTxt.text = userObj.uPhone

            
            if let interests = (currnetUser as! normalUser).intrests{
                self.intrestsArr = interests
            }
           
        }
    }
    
    @IBAction func changePassBtnPressed(_ sender: Any) {
        self.menuBtnPressed(self) //to hide menu
        //prepare
        self.CPPassTxt.text = ""
        self.CPComfPassTxt.text = ""
        //show
        self.addPopupView(pupupView: self.changePassView)
    }
    
    @IBAction func addExpBtnPressed(_ sender:Any){
        self.menuBtnPressed(self) //to hide menu
        self.updateAddExpbView()
        self.addPopupView(pupupView: self.addExp_View)
    }
    
    @IBAction func reqSponsorBtnPressed(_ sender:Any){
        self.menuBtnPressed(self) //to hide menu
        performSegue(withIdentifier: "creatEventToSponsor", sender: nil)
    }
    
    @IBAction func impToEMBtnPressed(_ sender:Any){
        self.menuBtnPressed(self) //to hide menu
        self.updateImproveToEMView()
        self.addPopupView(pupupView: self.improveToEM_View)
    }
    
    @IBAction func contactUsBtnPressed(_ sender: Any) {
        let VC = storyboard?.instantiateViewController(withIdentifier: "ContactUsVC") as? ContactUsVC
        self.navigationController?.pushViewController(VC!, animated: true)
    }
    
    @IBAction func aboutUsBtnPressed(_ sender: Any) {
        let VC = storyboard?.instantiateViewController(withIdentifier: "AboutUsVC") as? AboutUsVC
        self.navigationController?.pushViewController(VC!, animated: true)
    }
    
    // Edit profile popup View actions
    
    @IBAction func EPCloseBtnPressed(_ sender: Any) {
        removePopupView(pupupView: self.editProfileView){}
    }
    
    @IBAction func addIntrestBtnPressed(_ sender: Any?) {
        performSegue(withIdentifier: "intrestsVC", sender: intrestsArr)
    }

    @IBAction func EPSaveBtnPressed(_ sender: Any) {
        let curUserObj = currnetUser
        if EPChekInput(){
            if currnetUser.uType == userGeneral.getEMStrFormat(){
                var newUserObj = curUserObj as! eventManager
                newUserObj.name = EPNameTxt.text
                newUserObj.uPhone = phoneNumTxt.text

                self.udateProfileFBInfo(newUserObj: newUserObj)
                
            } else if currnetUser.uType == userGeneral.getNUStrFormat(){
                var newUserObj = curUserObj as! normalUser
                newUserObj.name = EPNameTxt.text
                newUserObj.uPhone = phoneNumTxt.text
                newUserObj.intrests = intrestsArr
                self.udateProfileFBInfo(newUserObj: newUserObj)
            }
        }
    }
    
    func EPChekInput()-> Bool{
        if EPNameTxt.text == ""{
            notificationHelper.notificationHelperObj.showError(callerVC: self, Err: "Name should Not be empty!", color: .red)
            return false
        }
        if phoneNumTxt.text?.count != 9 {
            notificationHelper.notificationHelperObj.showError(callerVC: self, Err: "Phone-Number should be 9 digits!", color: .red)
            return false
        }
        return true

    }
    
    func udateProfileFBInfo(newUserObj:userGeneral){
        refrishingHanler.refrishingHanlerObj.startRefrising(view: self.view)
        FBDBHandler.FBDBHandlerObj.updateUser(newUserObj: newUserObj, onSucces: {
            refrishingHanler.refrishingHanlerObj.endRefrising(view: self.view)
            self.removePopupView(pupupView: self.editProfileView, Comp: { self.updateView()})
        }, onError: {
            refrishingHanler.refrishingHanlerObj.endRefrising(view: self.view)
        })
    }
    
    @objc func handleSelectProfileProfileImageView() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    // Change password popup view actions
    @IBAction func CPCloseBtnPressed(_ sender: Any) {
        removePopupView(pupupView: self.changePassView){}
    }
    
    @IBAction func CPSaveBtnPressed(_ sender: Any) {
        if CPCeckImput(){
            if let newPass = CPPassTxt.text{
                self.udateProfileFBPassword(newPass: newPass)
            }
        }
    }
    
    func CPCeckImput() -> Bool{
        if self.CPPassTxt.text != "" && self.CPComfPassTxt.text != ""{
            if self.CPPassTxt.text == self.CPComfPassTxt.text {
                if CPComfPassTxt.text!.count >= 6{
                    return true
                }
                ErrorHndeler.ErrorHndelerObj.showLblError2(TextField: CPPassTxt, ErrMsg: "Shoud be >= 6 digits!",moveUpBy:90)
                ErrorHndeler.ErrorHndelerObj.showLblError2(TextField: CPComfPassTxt, ErrMsg: "Shoud be >= 6 digits!",moveUpBy:170)
                return false
            }
            ErrorHndeler.ErrorHndelerObj.showLblError2(TextField: CPPassTxt, ErrMsg: "Pass and ComfPass Shoud be the same!",moveUpBy:90)
            ErrorHndeler.ErrorHndelerObj.showLblError2(TextField: CPComfPassTxt, ErrMsg: "Pass and ComfPass Shoud be the same!",moveUpBy:170)
            return false
        }
        ErrorHndeler.ErrorHndelerObj.showLblError2(TextField: CPPassTxt, ErrMsg: "Shoud Not be empty!",moveUpBy:90)
        ErrorHndeler.ErrorHndelerObj.showLblError2(TextField: CPComfPassTxt, ErrMsg: "Shoud Not be empty!",moveUpBy:170)
        return false
    }
    func udateProfileFBPassword(newPass:String){
        refrishingHanler.refrishingHanlerObj.startRefrising(view: self.view)
        FBDBHandler.FBDBHandlerObj.resetCurrUserPassWord(newPass: newPass, onSucces: {
            refrishingHanler.refrishingHanlerObj.endRefrising(view: self.view)
            self.removePopupView(pupupView: self.changePassView, Comp: { self.updateView()})

        }, onError: {
            refrishingHanler.refrishingHanlerObj.endRefrising(view: self.view)

        })
    }
    
    //MARK:- AddExpb Popup actions
    @IBAction func AE_CloseBtnPressed(_ sender:Any){
        removePopupView(pupupView: self.addExp_View){}

    }
    
    @IBAction func AE_SaveBtnPressed(_ sender:Any){
        if let user = currnetUser as? normalUser,
            let expTxt = self.AE_ExpDescTxt.text{
            if expTxt == "" {// the textfiled is empty!
                notificationHelper.notificationHelperObj.showError(callerVC: self, Err: "exp description can Not be empty!", color: .red)
            } else { //not empty -> start updating profile info
                user.experians = expTxt
                
                //strat refriting view
                refrishingHanler.refrishingHanlerObj.startRefrising(view: self.view)
                //start FB_process
                FBDBHandler.FBDBHandlerObj.updateUser(newUserObj: user, onSucces: {
                    refrishingHanler.refrishingHanlerObj.endRefrising(view: self.view)
                    self.removePopupView(pupupView: self.addExp_View, Comp: { self.updateView()})
                }, onError: {
                    refrishingHanler.refrishingHanlerObj.endRefrising(view: self.view)
                    
                })
                
            }
        } else {// error: didnt get the object of textfiled
            notificationHelper.notificationHelperObj.showError(callerVC: self, Err: "exp description can Not be empty!", color: .red)
        }
    }
    
    func updateAddExpbView(){
        if let user = currnetUser as? normalUser,
            let exp = user.experians{
            exp == "" ? (self.AE_ExpDescTxt.text = "no expereance added :(") : (self.AE_ExpDescTxt.text = exp)
        } else {
            self.AE_ExpDescTxt.text = "no expereance added :("
        }
    }
    
     // WIll be changed
    //MARK:- ReqSponsor Popup actions
//    @IBAction func RS_CloseBtnPressed(_ sender:Any){
//        removePopupView(pupupView: self.reqSponsor_View){}
//    }
//    @IBAction func RS_SendReqBtnPressed(_ sender:Any){
//        if let title = RS_TitelTxt.text,
//            let Desc = RS_DescriptionTxt.text{
//            if title == "" || Desc == "" { // the textfileds empty!
//                notificationHelper.notificationHelperObj.showError(callerVC: self, Err: "Fill all info!", color: .red)
//            }else{ // not empty -> start FP_Process
//
//            }
//
//        }else{ // error: didnt get the object of textfiled
//            notificationHelper.notificationHelperObj.showError(callerVC: self, Err: "Fill all info!", color: .red)
//
//        }
//    }
//    func updateReqSponsorView(){
//        self.RS_TitelTxt.text = ""
//        self.RS_DescriptionTxt.text = ""
//    }
    
    
    // Improve to event manager popup actions
    @IBAction func ITEM_CloseBtnPressed(_ sender:Any){
        removePopupView(pupupView: self.improveToEM_View){}
    }
    
    @IBAction func ITEM_SendReqBtnPressed(_ sender:Any){
        if  let user = currnetUser as? normalUser,
            let OrgName = ITEM_OrgNameTxt.text,
            let OrgAddrss = ITEM_OrgAddressTxt.text,
            let Reason = ITEM_ResoneTxt.text {
            
            //start-refreshing
            refrishingHanler.refrishingHanlerObj.startRefrising(view: self.view)
            
            if OrgName == "" || OrgAddrss == "" || Reason == ""{  // the textfileds empty!
                notificationHelper.notificationHelperObj.showError(callerVC: self, Err: "Fill all info!", color: .red)
                refrishingHanler.refrishingHanlerObj.endRefrising(view: self.view)
 
            }else{// not empty -> start FP_Process
                if let uid = user.UID,
                    let uType = userGeneral.getEMStrFormat() as? String,
                    let email = user.uEmail,
                    let phone = user.uPhone,
                    let name = OrgName as? String,
                    let address = OrgAddrss as? String,
                    let city = user.city
                {
                    let newUserObj:eventManager = eventManager(UID: uid, picURL: "", uType: uType, uEmail: email, uPhone: phone, uPassword: "", uStatus: false, name: name, address: address, MyEvents: [], city: city,MyNotifcation:[])
                    
                    FBDBHandler.FBDBHandlerObj.ReqImprovFromNUToEM(EMUserObj: newUserObj, onSucces: {
                        notificationHelper.notificationHelperObj.showError(callerVC: self, Err: "Requst Sent!", color: .green)
                        refrishingHanler.refrishingHanlerObj.endRefrising(view: self.view)
                        self.ITEM_CloseBtnPressed(self)
                        

                    }, onError: {
                        notificationHelper.notificationHelperObj.showError(callerVC: self, Err: "somthing went wrong!", color: .red)
                        refrishingHanler.refrishingHanlerObj.endRefrising(view: self.view)

                    })
                } else {
                    refrishingHanler.refrishingHanlerObj.endRefrising(view: self.view)
                }
            }
        } else { // error: didnt get the object of textfiled
                notificationHelper.notificationHelperObj.showError(callerVC: self, Err: "Fill all info!", color: .red)
            refrishingHanler.refrishingHanlerObj.endRefrising(view: self.view)
        }
    }
    
    func updateImproveToEMView(){
        self.ITEM_OrgNameTxt.text = ""
        self.ITEM_OrgAddressTxt.text = ""
        self.ITEM_ResoneTxt.text = ""
    }
    
    func showAndUpdateVolStars(){
        if currnetUser.uType == userGeneral.getNUStrFormat() {//check wether the user is volunter
            if (currnetUser as! normalUser).didVol{
                //prepare
                theWholeStarsView.isHidden = false
                starsLbl.text = "0"
                starNo5.tintColor = UIColor.white
                starNo4.tintColor = UIColor.white
                starNo3.tintColor = UIColor.white
                starNo2.tintColor = UIColor.white
                starNo1.tintColor = UIColor.white
                
                //start proccess
                starsLbl.text = String(format: "%03d", ((currnetUser as! normalUser).numrRates ?? 0))
                
                let numofStars:Int = (currnetUser as! normalUser).getNumOfStarsToShow()
                
                switch numofStars {
                case 5:
                    starNo5.tintColor = UIColor(named: "orangRed1")
                    starNo4.tintColor = UIColor(named: "orangRed1")
                    starNo3.tintColor = UIColor(named: "orangRed1")
                    starNo2.tintColor = UIColor(named: "orangRed1")
                    starNo1.tintColor = UIColor(named: "orangRed1")
                    break
                case 4:
                    starNo5.tintColor = UIColor.white
                    starNo4.tintColor = UIColor(named: "orangRed1")
                    starNo3.tintColor = UIColor(named: "orangRed1")
                    starNo2.tintColor = UIColor(named: "orangRed1")
                    starNo1.tintColor = UIColor(named: "orangRed1")
                    break
                case 3:
                    starNo5.tintColor = UIColor.white
                    starNo4.tintColor = UIColor.white
                    starNo3.tintColor = UIColor(named: "orangRed1")
                    starNo2.tintColor = UIColor(named: "orangRed1")
                    starNo1.tintColor = UIColor(named: "orangRed1")
                    break
                case 2:
                    starNo5.tintColor = UIColor.white
                    starNo4.tintColor = UIColor.white
                    starNo3.tintColor = UIColor.white
                    starNo2.tintColor = UIColor(named: "orangRed1")
                    starNo1.tintColor = UIColor(named: "orangRed1")
                case 1:
                    starNo5.tintColor = UIColor.white
                    starNo4.tintColor = UIColor.white
                    starNo3.tintColor = UIColor.white
                    starNo2.tintColor = UIColor.white
                    starNo1.tintColor = UIColor(named: "orangRed1")
                    break
                default:
                    break
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destnation = segue.destination as? showEvntsListVC {
            if let evesArrObj = sender as? [Event]{
                destnation.Events = evesArrObj
                
                if whatBtnPressed == "eveToSponsor"{
                    destnation.isItToSponsor = true
                }else{
                    destnation.isItToSponsor = false

                }
            }
        }
            
        else if let destnation = segue.destination as? ViewEventVC {
            if let evesObj = sender as? Event{
                destnation.EveHolder = evesObj
            }
        } else if let destnation = segue.destination as? CreateEventVC {
            destnation.isItForSponsore = true
        }
            
        else if let destnation = segue.destination as? intrestsVC {
            if let intrestsArrObj = sender as? [String]{
                destnation.ArrayOfIntrests = intrestsArrObj
                destnation.callerVC = self
            }
        }

    }
}

extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("Picked a photo")
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = image
            EPImgView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}

extension ProfileVC : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case EPNameTxt:
            let maxLength = 40
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            let flag = newString.length <= maxLength
            if !flag{
                notificationHelper.notificationHelperObj.showError(callerVC: self, Err: "cant be more than \(maxLength) digints", color: .orange)
            }
            return flag
        case ITEM_OrgNameTxt:
            let maxLength = 40
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            let flag = newString.length <= maxLength
            if !flag{
                notificationHelper.notificationHelperObj.showError(callerVC: self, Err: "cant be more than \(maxLength) digints", color: .orange)
            }
            return flag
        case phoneNumTxt:
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

        case CPPassTxt:
            let maxLength = 30
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            let flag = newString.length <= maxLength
            if !flag{
                notificationHelper.notificationHelperObj.showError(callerVC: self, Err: "cant be more than \(maxLength) digints", color: .orange)
            }
            return flag
        case CPComfPassTxt:
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
    
}
