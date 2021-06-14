//
//  FBDBHandler.swift
//  Eventor
//
//  Created by YAZEED NASSER on 16/02/2019.
//  Copyright © 2019 Eventor. All rights reserved.
//
import SystemConfiguration
import Foundation
import Firebase

//NOTE: Tocall this object go like this -> FBDBHandler.FBDBHandlerObj.(funcName)
class FBDBHandler{
    static let FBDBHandlerObj: FBDBHandler = FBDBHandler.init()
    let Ref: DatabaseReference = Database.database().reference()
    let StorageRef = Storage.storage().reference(forURL: "gs://eventor-f52a8.appspot.com")


    private init(){
    }
    
    //to check whther is there any Internet connction or not (true:thereIsAnInternet,false:noInternet)
    func checkInternet(Lbl : (UILabel)? = nil) -> Bool{
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            
            //showing the network error msg
            if Lbl != nil{
                resultsAndAlertsObj.showErorr(reson: "check your connection", theLbl: Lbl!)
            }
            return false
        }
       
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        //showing the network error msg
        if ret == false && Lbl != nil{
            resultsAndAlertsObj.showErorr(reson: "check your connection" , theLbl: Lbl!)
        }
        return ret
       
    }
    
    //Auth (signIn)
    func signIn(email: String, password: String, onSucces: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            //load the current userObj
            if let UID:String = Auth.auth().currentUser?.uid{
                self.loadMyUser(UID: UID){
                    if currnetUser.uStatus == false {
                        self.signOut()
                        onError("Sorry Your Account Is disabled!")
                        
                    }else{
                        onSucces()
                    }
                    }
            }
        })
    }
    
    //Auth (signUp)
    func signUp(uType: String, uEmail: String, uPhone: String, uPassword: String,uStatus: Bool, name: String, address: String, DOB: date, city: String, experians: String, imageData: Data, onSucces: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {

        
        Auth.auth().createUser(withEmail: uEmail, password: uPassword, completion: { (user, error: Error?) in
            if (error != nil) {
                onError(error!.localizedDescription)
                return
            }
            
            let UID = (Auth.auth().currentUser?.uid)!
            let ProfileImageRef = self.StorageRef.child("ProfileImage").child(UID)
            ProfileImageRef.putData(imageData, metadata: nil) { (metadata, error) in
                if error != nil {
                    return
                }
                ProfileImageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        // Uh-oh, an error occurred!
                        return
                    }
                    //0-geting the url for the profileImage
                    let ProfileImageURL = downloadURL
                    let ProfileImageURLString = ProfileImageURL.absoluteString
                    
                    //1-craeting User Object (For Any type)
                    let UserObj:userGeneral = self.creatUserObj(UID: UID, picURL: ProfileImageURLString, uType: uType, uEmail: uEmail, uPhone: uPhone, uPassword: uPassword,name: name, uStatus: uStatus, address: address, DOB: DOB, city: city, experians: experians, numrRates: 0, totalRate: 0)
                    
                    //2-changing current User Object
                    currnetUser = UserObj
                    
                    //3-genrating Dectinory User Object for the Datebase
                    let UserObjDec:[String:Any] = self.genrateDecForUserObbj(UserObj: UserObj)
                    
                    //4-save to the Database
                    self.Ref.child("Users").child(UID).setValue(UserObjDec)
                    
                   onSucces()

                }
            }
        })
    }
    
    func ReqEveManagerAcc(EMUserObj:eventManager, imageData: Data, onSucces: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void){
        if let uEmail = EMUserObj.uEmail,
            let uPhone = EMUserObj.uPhone,
            let uPassword = EMUserObj.uPassword,
            let name = EMUserObj.name,
            let address = EMUserObj.address,
            let city = EMUserObj.city
            
       {
        self.signUp(uType: userGeneral.getEMStrFormat(), uEmail: uEmail, uPhone: uPhone, uPassword: uPassword, uStatus: false, name: name, address: address, DOB: date.init(), city: city, experians: "", imageData: imageData, onSucces: {
            self.signOut()
            onSucces()
        }, onError: onError)
        
        }
    }
    
    func signOut(){
        do {
            try Auth.auth().signOut()
        }catch {
            
        }
    }
//Eve FB Methods -----
    func loadEves(){
        
    }
    func addEve(newEveObj:Event){
        
    }
    func udateEve(newEveObj:Event){
        
    }
    func deleteEve(EID:String){
        
    }
    
    
//[#] User FB Methods -----
    func loadMyUser(UID:String, onSucces: @escaping () -> Void){
        
        Ref.child("Users/\(UID)").observeSingleEvent(of: .value , with: { snapshot in
            if let UserDec = snapshot.value as? [String:Any]{
                let userObj:userGeneral = self.genrateUserObbjFromDec(UserDec: UserDec, UID: UID)
                currnetUser = userObj
                
                onSucces()
            }else{
                return
            }
        })
        
    }

    
    func addNewEveMgrReq(newUserObj:userGeneral, onSucces: @escaping () -> Void){
        
//        let newUserDec:[String:Any] = self.genrateDecForUserObbj(UserObj: newUserObj)
//        Ref.child("EventManagerUserReq").childByAutoId().updateChildValues(newUserDec)
//        print("new EVM request completed")
        
 
        onSucces()
    }
    
    func updateUser(newUserObj:userGeneral){
        if checkInternet(){
            let newUserDec:[String:Any] = self.genrateDecForUserObbj(UserObj: newUserObj)
            //user dectienory is ready to add to DB
            self.Ref.child("Users/\(newUserObj.UID!)").updateChildValues(newUserDec)
        }
    }
    
    func deleteUser(EID:String){
        //1-delete from all eves if vol
        // cuz thers no Admin acc in FB so to delete acc u have to sing in to it then delet it and return to ur acc
        //2.0 save ur current user (email,pass) in var
        //2.1 boserv the acc needed to delete (by UID) and get (email,pass)
        //2.2 logout from currnt acc
        //2.3 log in to the acc needed to delete
        
        //3.0 delet the acc from FB auth
        //-3.0.1 if: Vol : delet from all joined eves
        //3.1 delet from FB database
        //4 log in into the current acc
        
    }
    //[#] actions for normalUser -
        //-intrasts(funcs)
    func loadAllIntrests(UID:String){
        //loadIntrests and add them to the current user
    }
    func addIntrests(UID:String,intrest:String){
        let newIntrDec = ["\(intrest)":"\(intrest)"]
        self.Ref.child("Users/\(UID)/intrests").updateChildValues(newIntrDec)
    }
    func removeIntrests(UID:String,intrest:String){
        self.Ref.child("Users/\(UID)/intrests/\(intrest)").removeValue()
    }
        //-subscriptions(funcs)
    func loadAllSubs(UID:String){
        //loadsubscription and add them to the current user
    }
    func subscripEve(EID:String,UID:String){
        let newSubDec = ["\(EID)":"\(EID)"]
        self.Ref.child("Users/\(UID)/subEvents").updateChildValues(newSubDec)
    }
    func unSubscripEve(EID:String,UID:String){
        self.Ref.child("Users/\(UID)/subEvents/\(EID)").removeValue()
    }
    //[#] actions for Admin -
    func acceptUserReq(UserReqID:String,newUserObj:userGeneral){
    }
    func rejectVolReq(EID:String,UID:String){
        
    }
    func rateAcceptedVol(UID:String,Rate:Double){
        
    }

    //[#] actions for vol -
    func ReqVolInAnEve(EID:String,UID:String){
        
    }
    func removeVolInAnEve(EID:String,UID:String){
        
    }
    
//[#] Notifcations FB Methods -----
    func addNtfToUser(UID:String){ // it needs a notifcation obj to add (later)
        
    }
    
//[#] functions (getters)
    func getImageBy(URL:String,imageViewToLoadOn:UIImageView){
        imageViewToLoadOn.loadImageURLStringUsingCashe(StringURL: URL)
    }
    
//[#] privetFuncs Help
    private func genrateDecForEveObbj(EveObj:Event) -> [String:Any]{
        return [:]
    }
    private func creatUserObj(UID: String, picURL: String, uType: String, uEmail: String, uPhone: String, uPassword: String,name:String,uStatus:Bool,address:String,DOB:date,city:String,experians:String,numrRates:Int,totalRate:Double) -> userGeneral{
        
        let UserTpey:String = uType
        var UserObj = userGeneral.init(UID: "",picURL:"", uType: "", uEmail: "", uPhone: "", uPassword: "",uStatus: false)
        
        switch UserTpey{
            
        case (userGeneral.getEMStrFormat()) :// eventManager
            UserObj = eventManager.init(UID: UID, picURL: picURL, uType: uType, uEmail: uEmail, uPhone: uPhone, uPassword: uPassword,uStatus: uStatus, name: name, address: address, MyEvents: [], city : city)
            break
            
        case (userGeneral.getNUStrFormat()) : // normalUser
            UserObj = normalUser.init(UID: UID, picURL: picURL, uType: uType, uEmail: uEmail, uPhone: uPhone, uPassword: uPassword,uStatus: uStatus, name: name, intrests: [], subEvents: [], DOB: DOB, city: city, experians: experians, numrRates: numrRates, totalRate: totalRate)
            break
            
        case (userGeneral.getAdminStrFormat()) : // adminUser
            UserObj = admin.init(UID: UID, picURL: picURL, uType: uType, uEmail: uEmail, uPhone: uPhone, uPassword: uPassword,uStatus: uStatus)
            break
            
        default: break
        }
        
        return UserObj
    }
    
    private func genrateDecForUserObbj(UserObj:userGeneral) -> [String:Any]{
        let UserTpey:String = UserObj.uType
        var UserDec:[String:Any] = [:]
        
        switch UserTpey{
            
        case (userGeneral.getEMStrFormat()) :// eventManager
            let EMU:eventManager = UserObj as! eventManager
            UserDec = [
                "UType" : EMU.uType,
                "Email" : EMU.uEmail,
                "Phone" : EMU.uPhone,
                "passWord" : EMU.uPassword,
                "status" : EMU.uStatus,
                "city": EMU.city,
                "name": EMU.name,
                "pic": EMU.picURL,
                "address": EMU.address
                ] as [String:Any]
            break
            
        case (userGeneral.getNUStrFormat()) : // normalUser
            
            let NU:normalUser = UserObj as! normalUser
            UserDec = [
                "UType" : NU.uType,
                "Email" : NU.uEmail,
                "Phone" : NU.uPhone,
                "passWord" : NU.uPassword,
                "status" : NU.uStatus,
                "name": NU.name,
                "pic": NU.picURL,
                "city": NU.city,
                "DOB": ["Day":String(NU.DOB._D),"Mun":String(NU.DOB._M),"Year":String(NU.DOB._Y)],
                "experians": NU.experians,
                "rate": ["numRates": NU.numrRates, "totalRate": NU.totalRate]
                
                ] as [String:Any]
            break
            
        case (userGeneral.getAdminStrFormat()) : // admin
            let AdminU:admin = UserObj as! admin
            UserDec = [
                "UType" : AdminU.uType,
                "Email" : AdminU.uEmail,
                "Phone" : AdminU.uPhone,
                "passWord" : AdminU.uPassword,
                "status" : AdminU.uStatus

                ] as [String:Any]
            
            break
        default: break
            
        }
        
        return UserDec
    }
    
    private func genrateEveObbjFromDec(EveObj:[String:Any]) -> Event{

        return Event.init(EventNameTxt: "", AttendenceTypeTxt: "", EventDescriptionTxt: "", EventImageURLString: "", EMID: "", EFT: "", ETT: "", ED: "", Elatitude: 0, Elongitude: 0, postedDate: "")

        return Event.init(EventNameTxt: "", AttendenceTypeTxt: "", EventDescriptionTxt: "", EventImageURLString: "", EMID: "", EFT: "", ETT: "", ED: "", Elatitude: 0, Elongitude: 0, postedDate: "")

        
    }
    
    private func genrateUserObbjFromDec(UserDec:[String:Any],UID:String) -> userGeneral{
       
        if let UserTpey:String = UserDec["UType"] as? String,
            let picURL:String = UserDec["pic"] as? String,
            let Uemail:String = UserDec["Email"] as? String,
            let UPhone:String = UserDec["Phone"] as? String,
            let UPW:String = UserDec["passWord"] as? String,
            let status:Bool = UserDec["status"] as? Bool
        {
            switch UserTpey{
                
            case (userGeneral.getEMStrFormat()) :// eventManager
                if let EMName:String = UserDec["name"] as? String,
                    let EMCity:String = UserDec["city"] as? String,
                    let EMAddress:String = UserDec["address"] as? String{
                    
                    return eventManager.init(UID: UID,picURL:picURL, uType: UserTpey, uEmail: Uemail, uPhone: UPhone, uPassword: UPW,uStatus: status, name: EMName, address: EMAddress, MyEvents: [],city:EMCity)
                }
                break
            case (userGeneral.getNUStrFormat()) : // normalUser
                if let NUName:String = UserDec["name"] as? String,
                    let NUCity:String = UserDec["city"] as? String,
                    let DOBDec:[String:String] = UserDec["DOB"] as? [String:String],
                    let D:Int = Int((DOBDec["Day"] as! String)),
                    let M:String = DOBDec["Mun"] as? String,
                    let Y:Int = Int((DOBDec["Year"] as! String)),
                    let NUExp:String = UserDec["experians"] as? String,
                    let RateDec:[String:Any] = UserDec["rate"] as? [String:Any],
                    let numRates:Int = RateDec["numRates"] as? Int,
                    let totalRate:Double = RateDec["totalRate"] as? Double
                {
                    let DOB = date.init(D: D, M: M, Y: Y)

                    return normalUser.init(UID: UID,picURL:picURL, uType: UserTpey, uEmail: Uemail, uPhone: UPhone, uPassword: UPW,uStatus: status, name: NUName, intrests: [], subEvents: [],DOB:DOB,city: NUCity, experians: NUExp, numrRates: numRates, totalRate: totalRate)

                }
                break
            
            case (userGeneral.getAdminStrFormat()) : // admin
                return admin.init(UID: UID,picURL:picURL, uType: UserTpey, uEmail: Uemail, uPhone: UPhone, uPassword: UPW,uStatus: status)
                break
            default: break
                
            }//end switch
        }
        print("test [1.0.0]: user obj not genrated after getting info from FBDB!!")
        return userGeneral.init(UID: "",picURL:"", uType: "", uEmail: "", uPhone: "", uPassword: "",uStatus: false)

    }
    
}
