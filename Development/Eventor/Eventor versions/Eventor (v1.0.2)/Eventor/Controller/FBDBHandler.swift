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

// NOTE: To call this object go like this -> FBDBHandler.FBDBHandlerObj.(funcName)
class FBDBHandler {
    static var FBAppVer:String = ""
    static let FBDBHandlerObj: FBDBHandler = FBDBHandler.init()
    let Ref: DatabaseReference = Database.database().reference()
    let StorageRef = Storage.storage().reference(forURL: "gs://eventor-f52a8.appspot.com")
    
    private init(){
        
    }
    
    // Check whether is there any Internet connction or not (true: thereIsAnInterest, false: noInternet)
    
    func checkInternet(Lbl : (UILabel)? = nil, VC : (UIViewController)? = nil) -> Bool {
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
            
            // Showing network error msg
            if Lbl != nil{
                resultsAndAlertsObj.showErorr(reson: "check your connection", theLbl: Lbl!)
            }else if VC != nil {
                notificationHelper.notificationHelperObj.showError(callerVC: VC!, Err: "check your connection", color: .red)
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
        } else if ret == false && VC != nil {
            notificationHelper.notificationHelperObj.showError(callerVC: VC!, Err: "check your connection", color: .red)
        }
        return ret
    }
    
    // Sign in
    func signIn(email: String, password: String, onSucces: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            // Load the current userObj
            if let UID:String = Auth.auth().currentUser?.uid{
                self.loadMyUser(UID: UID){
                    if currnetUser.uStatus == false {
                        self.signOut()
                        onError("Sorry Your Account Is disabled!")
                        
                    } else {
                        onSucces()
                    }
                }
            }
            
        })
    }
    
    // Sign up
    func signUp(uType: String, uEmail: String, uPhone: String, uPassword: String,uStatus: Bool, name: String,intrests: [String], address: String, DOB: date, city: String, experians: String, imageData: Data, onSucces: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
        
        Auth.auth().createUser(withEmail: uEmail, password: uPassword, completion: { (user, error: Error?) in
            if (error != nil) {
                onError(error!.localizedDescription)
                return
            }
            
            //send confiramation email to the new user
            Auth.auth().currentUser?.sendEmailVerification { (error) in
                if let error = error {
                    print("Error when sending Email verification is \(error)")
                }
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
                    let UserObj:userGeneral = self.creatUserObj(UID: UID, picURL: ProfileImageURLString, uType: uType, uEmail: uEmail, uPhone: uPhone, uPassword: uPassword,name: name,intrests: intrests, uStatus: uStatus, address: address, DOB: DOB, city: city, experians: experians, numrRates: 0, totalRate: 0,didVol:false)
                    
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
    
    // Sign out
    func signOut(){
        do {
            try Auth.auth().signOut()
        } catch {
            
        }
    }
    
    func ReqEveManagerAcc(EMUserObj:eventManager, imageData: Data, onSucces: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void){
        if let uEmail = EMUserObj.uEmail,
            let uPhone = EMUserObj.uPhone,
            let uPassword = EMUserObj.uPassword,
            let name = EMUserObj.name,
            let address = EMUserObj.address,
            let city = EMUserObj.city {
        self.signUp(uType: userGeneral.getEMStrFormat(), uEmail: uEmail, uPhone: uPhone, uPassword: uPassword, uStatus: false, name: name,intrests : [], address: address, DOB: date.init(), city: city, experians: "", imageData: imageData, onSucces: {
            self.signOut()
            onSucces()
        }, onError: onError)
        }
    }
    
    func ReqImprovFromNUToEM(EMUserObj:eventManager, onSucces: @escaping () -> Void, onError: @escaping () -> Void){
        if  let uid = EMUserObj.UID,
            let EMUserDec:[String:Any] = genrateDecForUserObbj(UserObj: EMUserObj){
            if uid != ""{
                Ref.child("ImprovrToEMReq/\(uid)").setValue(EMUserDec,withCompletionBlock: { (error, ref) in
                    if error == nil {
                        onSucces()

                    } else {
                        onError()
                    }
                })
            } else {
                onError()
            }
        } else {
            onError()
        }
    }
    
    // Load app version
    func loadFBAppVersion( onSucces: @escaping () -> Void, onError: @escaping () -> Void){
        self.Ref.child("AppMinSupportedVersion").observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            print(snapshot)
            if let VerDec = snapshot.value as? [String:String],
                let ver = VerDec["ver"] as? String{
                    FBDBHandler.FBAppVer = ver
                    onSucces()
            }else{
                onError()
            }
        }
    }
    
    // Load Events
    func loadEves( onSucces: @escaping () -> Void, onError: @escaping (_ errorMessage: (String)) -> Void){
        allEventsGlobalArry = []
        allEventsToSponsorGlobalArry = []
        
        self.Ref.child("Events").queryOrdered(byChild: "PostedDate").observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            print(snapshot)
            if let eveList = snapshot.value as? [String:[String:Any]]{
                print(eveList)
                for eveDec in eveList {
                    let eveObj:Event = self.genrateEveObbjFromDec(EveDec: eveDec.value, EID: eveDec.key)
                    
                    if eveObj.EID != ""{
                        if eveObj.EventManagerID != ""{ // load normal event
                            allEventsGlobalArry.insert(eveObj, at: 0)
                            print(eveDec.key)
                        } else if eveObj.EventManagerID == ""{ // load event to sponsor
                            allEventsToSponsorGlobalArry.insert(eveObj, at: 0)
                            print(eveDec.key)
                        }
                    }
                    
                }//end-for
            }
            onSucces()
        }
      
    }
 
    // Load Users
    func loadUsers( onSucces: @escaping () -> Void, onError: @escaping (_ errorMessage: (String)) -> Void){
        allUsersGlobalArry = []
        self.Ref.child("Users").observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            print(snapshot)
            if let usrList = snapshot.value as? [String:[String:Any]]{
                print("Here are the users")
                print(usrList)
                for userDec in usrList{
                    let userObj:userGeneral = self.genrateUserObbjFromDec(UserDec: userDec.value, UID: userDec.key)
                    
                    if userObj.UID != ""{
                        allUsersGlobalArry.append(userObj)
                        print(userDec.key)
                    }
                    
                }
            }
            onSucces()
        }
    }
    
    //
    func loadIdOfSubscribedEvents(UID:String,completion:  @escaping () -> Void){
        if (currnetUser.uType == userGeneral.getNUStrFormat()){
            (currnetUser as! normalUser).subEvents = []
            self.Ref.child("Users/\(UID)/subEvents").observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
                print(snapshot)
                if let sbList = snapshot.value as? [String:String]{
                    print(sbList)
                    for subEve in sbList{
                        (currnetUser as! normalUser).subEvents?.append(subEve.key)
                        print(subEve.key)
                    }
                }
                completion()
            }
            return
        }
        print("Error: userType is NOT NormalUser Or Volunteer ")
    }
    
    func loadIdOfSubscribers(EventObj:Event , completion:  @escaping () -> Void){
        EventObj.subUsers = []
        self.Ref.child("Events/\(EventObj.EID!)/subs").observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            if let SubsList = snapshot.value as? [String:String]{
                for subscribers in SubsList {
                    EventObj.subUsers?.append(subscribers.key)
                }
            }
            completion()
        }
        return
    }
    
    //
    func loadEventsUserVoledIn(UID:String,completion:  @escaping () -> Void){ // events User has been volunteering in or (joined)
        if (currnetUser.uType == userGeneral.getNUStrFormat()){
            (currnetUser as! normalUser).volEvents = []
            self.Ref.child("Users/\(UID)/volEvents").observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
                print(snapshot)
                if let volList = snapshot.value as? [String:Bool]{
                    print(volList)
                    for volEve in volList{
                        let volEve:EvePerson = EvePerson(EID: volEve.key, didAccepted: volEve.value)
                        (currnetUser as! normalUser).volEvents?.append(volEve)
                    }
                }
                completion()
            }
            return
        }
        print("Error: userType is NOT NormalUser Or Volunteer ")
    }
    
    //
    func loadVolunteersInEvent(EventObj:Event,completion:  @escaping () -> Void){// events User has been volunteering in or (joined)
        if (currnetUser.uType == userGeneral.getEMStrFormat()){
            EventObj.EventVols = []
            self.Ref.child("Events/\(EventObj.EID!)/vols").observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
                if let volList = snapshot.value as? [String:Bool]{
                    for voluser in volList{
                        if let userObj:normalUser = userGeneral.getUserObjBy(UID: voluser.key) as? normalUser{
                            let vol:EvePerson = EvePerson(volObj: userObj,didAccepted: voluser.value)
                            EventObj.EventVols?.append(vol)
                        }
                        
                    }
                }
                completion()
            }
            return
        }
        print("Error: userType is NOT An EvntManger account ")
    }
    
    
    func loadMyEventsID(UID:String,completion:  @escaping () -> Void){
        if (currnetUser.uType == userGeneral.getEMStrFormat()){
            (currnetUser as! eventManager).MyEvents = []
            self.Ref.child("Users/\(UID)/myEvents").observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
                print(snapshot)
                if let sbList = snapshot.value as? [String:String]{
                    print(sbList)
                    for subEve in sbList{
                        (currnetUser as! eventManager).MyEvents?.append(subEve.key)
                        print(subEve.key)
                    }
                }
                completion()
            }
            return
        }
        print("Error: userType is NOT An EvntManger account ")
    }

    
    func loedNUReqTobeEM(completion: @escaping () -> Void){
         NUReqTobeEM = []
        self.Ref.child("ImprovrToEMReq").observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            
            if let ReqList = snapshot.value as? [String:[String : Any]]{
                print(ReqList)
                for req in ReqList{
                    let userReq:userGeneral = self.genrateUserObbjFromDec(UserDec: req.value, UID: req.key)
                    NUReqTobeEM.append(userReq)
                }
            }
            completion()
        }
        
    }
    
    
    func searchForEvents(keyWord:String,filterBy:String?,onSucces: @escaping () -> Void, onError: @escaping (_ errorMessage: (String)) -> Void){
        allEventsGlobalArry = []
        
        Ref.child("Events").queryOrdered(byChild: "PostedDate").observe( .childAdded){ (snapshot: DataSnapshot) in
            
            if let dict = snapshot.value as? [String: Any],
                let EID = snapshot.key as? String,
                let EventName:String = dict["EventName"] as? String,
                let AttendenceType:String = dict["AttendenceType"] as? String{
                
                if self.checkForSearsh(keyWord , filterBy ,EventName , AttendenceType){
                    let eveObj:Event = self.genrateEveObbjFromDec(EveDec: dict, EID: EID)
                    allEventsGlobalArry.insert(eveObj, at: 0)
                    allEventsGlobalArry.reversed()
                }
            }
            onSucces()
        }
        
        
        //MARK:Warning testing searchForEvnts
        EventorTesting.EvntorTestObj.WarningTestMsgFor(testKeySymbol: "t", funcName: "searchForEvnts", inFileName: "FBDBHandler", testingVersion: 1, testerName: "Yazeed", testerMsg: "we need to test if the result dose NOT change after refreashing!! the page")
    }

    private func checkForSearsh(_ keyWord:String,_ filterBy:String?,_ EveName:String,_ AttendenceType:String) -> Bool{
        
        if let filter = filterBy {
            return  (EveName.lowercased().contains(keyWord.lowercased())) && (filter == AttendenceType)
            
        }else{
            return (EveName.lowercased().contains(keyWord.lowercased()))
        }
    }
    
    func addEve(newEveObj:Event,  onSucces: @escaping () -> Void, onError: @escaping () -> Void ){
        if  let newEventID:String = Ref.child("Events").childByAutoId().key,
            let UID:String = newEveObj.EventManagerID as? String{
                let eventDect:[String:Any] = self.genrateDecForEveObbj(EveObj: newEveObj)
                let forUserDec:[String:String] = [newEventID:newEventID]
                Ref.child("Users/\(UID)/myEvents").updateChildValues(forUserDec)
                Ref.child("Events/\(newEventID)").updateChildValues(eventDect,withCompletionBlock: { (error, ref) in
                    if (error != nil) {
                        ProgressHUD.showError(error!.localizedDescription)
                        onError()
                    }else{
                        onSucces()
                        if let EveInterests = newEveObj.EventIntrests {
                            FBDBHandler.FBDBHandlerObj.addNtfToAllUsersMatchInterests(EID: newEventID, EveInterests: EveInterests)
                        }

                    }
                })
        }
  
        //MARK:Warning testing addEve
        EventorTesting.EvntorTestObj.WarningTestMsgFor(testKeySymbol: "t", funcName: "addEve", inFileName: "FBDBHandler", testingVersion: 1, testerName: "Yazeed", testerMsg: "we need to test it with create Event")

    }
    
    func addEveReqToSponsor(newEveObj:Event,  onSucces: @escaping () -> Void, onError: @escaping () -> Void ){
        if  let newEventID:String = Ref.child("Events").childByAutoId().key,
            let UID:String = currnetUser.UID as? String{
            let eventDect:[String:Any] = self.genrateDecForEveObbj(EveObj: newEveObj)
            let forUserDec:[String:String] = [newEventID:newEventID]
            Ref.child("Users/\(UID)/ReqSponsorEvents").updateChildValues(forUserDec)
            Ref.child("Events/\(newEventID)").updateChildValues(eventDect,withCompletionBlock: { (error, ref) in
                if (error != nil) {
                    ProgressHUD.showError(error!.localizedDescription)
                    onError()
                }else{
                    onSucces()
                }
            })
        }
        
        //MARK:Warning testing addEve
        EventorTesting.EvntorTestObj.WarningTestMsgFor(testKeySymbol: "t", funcName: "addEve", inFileName: "FBDBHandler", testingVersion: 1, testerName: "Yazeed", testerMsg: "we need to test it with create Event")
        
    }
    
    func updateEve(newEveObj:Event, onSucces: @escaping () -> Void, onError: @escaping () -> Void ){
        if let currentEventID:String = newEveObj.EID {
            let eventDect:[String:Any] = self.genrateDecForEveObbj(EveObj: newEveObj)
            Ref.child("Events/\(currentEventID)").updateChildValues(eventDect,withCompletionBlock: { (error, ref) in
                if (error != nil) {
                    ProgressHUD.showError(error!.localizedDescription)
                    onError()
                }else{
                    onSucces()
                    
                    if let EveInterests = newEveObj.EventIntrests,
                        let EID = newEveObj.EID{
                        FBDBHandler.FBDBHandlerObj.addNtfToAllUsersMatchInterests(EID: EID, EveInterests: EveInterests)
                    }
                    
                }
            })
        }
        
       
        
        
        //MARK:Warning testing updateEve
        EventorTesting.EvntorTestObj.WarningTestMsgFor(testKeySymbol: "t", funcName: "updateEve", inFileName: "FBDBHandler", testingVersion: 1, testerName: "Yazeed", testerMsg: "")
        
    }
    
    func sponsorAnEvent(UID:String,EID:String, onSucces: @escaping () -> Void, onError: @escaping () -> Void){
        if UID != "" && EID != ""{
            Ref.child("Users/\(UID)/myEvents/\(EID)").setValue(EID,withCompletionBlock: { (error, ref) in
                if (error != nil) {
                    onError()
                }else{
                    self.Ref.child("Events/\(EID)/EventManagerID").setValue(UID,withCompletionBlock: { (error, ref) in
                        if (error != nil) {
                            onError()
                        }else{
                            onSucces()
                        }
                    })
                }
            })
            
        }else{
            onError()
        }
    }
    
    func deleteEve(EID:String, onSucces: @escaping () -> Void, onError: @escaping () -> Void ){
        Ref.child("Events/\(EID)").removeValue(completionBlock: { (error, ref) in
            if (error != nil) {
                ProgressHUD.showError(error!.localizedDescription)
                onError()
            }else{
                onSucces()
            }
        })
        
        //MARK:Warning testing deleteEve
        EventorTesting.EvntorTestObj.WarningTestMsgFor(testKeySymbol: "t", funcName: "deleteEve", inFileName: "FBDBHandler", testingVersion: 1, testerName: "Yazeed", testerMsg: "")
        
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
        let newUserDec:[String:Any] = self.genrateDecForUserObbj(UserObj: newUserObj)
        Ref.child("EventManagerUserReq").childByAutoId().updateChildValues(newUserDec)
        print("new EVM request completed")
        onSucces()
    }
    
    func updateUser(newUserObj:userGeneral, onSucces: @escaping () -> Void, onError: @escaping () -> Void){
        if checkInternet(){
            let newUserDec:[String:Any] = self.genrateDecForUserObbj(UserObj: newUserObj)
            //user dectienory is ready to add to DB
            self.Ref.child("Users/\(newUserObj.UID!)").updateChildValues(newUserDec,withCompletionBlock: { (error, ref) in
                if (error != nil) {
                    ProgressHUD.showError(error!.localizedDescription)
                    onError()
                }else{
                    ProgressHUD.showSuccess("Success")
                    currnetUser = newUserObj
                    onSucces()
                }
            })
        }
    }
    
    func resetCurrUserPassWord(newPass:String, onSucces: @escaping () -> Void, onError: @escaping () -> Void){
        if(newPass.count >= 6){
            Auth.auth().currentUser?.updatePassword(to: newPass){  error in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    onError()
                }else{
                    let newUserObj = currnetUser
                    newUserObj.uPassword = newPass
                    self.updateUser(newUserObj: newUserObj, onSucces: {onSucces()} , onError: {onError()})
                }
                
            }
        } // password changed
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
    
    func subscripEve(EID:String,UID:String){
        let newSubDec = ["\(EID)":"\(EID)"]
        self.Ref.child("Users/\(UID)/subEvents").updateChildValues(newSubDec)
        let newUserSubDec = ["\(UID)":"\(UID)"]
        self.Ref.child("Events/\(EID)/subs").updateChildValues(newUserSubDec)
    }
    
    func unSubscripEve(EID:String,UID:String){
        self.Ref.child("Users/\(UID)/subEvents/\(EID)").removeValue()
        self.Ref.child("Events/\(EID)/subs/\(UID)").removeValue()
    }
  
    // Methods for volunteer
    
    func ReqVolInAnEve(EID:String,UID:String){
        let forEveDec = ["\(UID)":false]
        let forUserDec = ["\(EID)":false]
        self.Ref.child("Users/\(UID)/volEvents").updateChildValues(forUserDec)
        self.Ref.child("Events/\(EID)/vols").updateChildValues(forEveDec)
        
        
       
    }
    
    func removeVolInAnEve(EID:String,UID:String){
        self.Ref.child("Users/\(UID)/volEvents/\(EID)").removeValue()
        self.Ref.child("Events/\(EID)/vols/\(UID)").removeValue()
    }
    
 
    //Methods for event-manager
    func rejectVolReq(EID:String,UID:String){
        self.Ref.child("Events/\(EID)/vols/\(UID)").removeValue()
        self.Ref.child("Users/\(UID)/volEvents/\(EID)").removeValue()
        
        //notifcation
        addNtfRejectedToVolForVolUser(EID: EID, VolUID: UID)
    }
    
    func acceptVolReq(EID:String,UID:String){
        //let forUserDec = ["\(EID)":true]
        //self.Ref.child("Users/\(UID)/volEvents").updateChildValues(forUserDec)
        let forEveDec = ["\(UID)":true]
        let udateUserVol = ["didVol":true,"volEvents":["\(EID)":true]] as [String : Any]
        self.Ref.child("Users/\(UID)").updateChildValues(udateUserVol)
        self.Ref.child("Events/\(EID)/vols").updateChildValues(forEveDec)
        
        //notifcation
        addNtfAcceptedToVolForVolUser(EID: EID, VolUID: UID)
    }
    
    func rateAcceptedVol(EID:String,UID:String,Rate:Double){
        if let volToReat:normalUser = userGeneral.getUserObjBy(UID: UID) as! normalUser{
            rejectVolReq(EID: EID, UID: UID)
            let udateUserVol = ["rate":["numRates":volToReat.numrRates + 1,"totalRate":volToReat.totalRate + Rate]] as [String : Any]
            self.Ref.child("Users/\(UID)").updateChildValues(udateUserVol)
        }
    }
    
    func deleteUser(UID:String,onSucces: @escaping () -> Void, onError: @escaping () -> Void){
        
        let url = URL(string: "https://us-central1-eventor-f52a8.cloudfunctions.net/deleteUser")!
        let jsonDict = ["uid": "\(UID)"] as! [String: String]
        let jsonData = try! JSONSerialization.data(withJSONObject: jsonDict, options: [])
        print(jsonData)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil && (response as! HTTPURLResponse).statusCode == 200 {
                self.Ref.child("Users/\(UID)").removeValue()
                onSucces()
            }else{
                onError()
            }
        }
        task.resume()
        
    }

    // Get Image
    func getImageBy(URL:String,imageViewToLoadOn:UIImageView){
        imageViewToLoadOn.loadImageURLStringUsingCashe(StringURL: URL)
    }
    
    
    
    // Methods for admin
    
    func acceptNUserToBeEMReq(UID:String,newUserObj:userGeneral,onSucces: @escaping () -> Void, onError: @escaping () -> Void){
        if var UserDec:[String:Any] = self.genrateDecForUserObbj(UserObj: newUserObj){
            UserDec["status"] = true
            //to save user current password
            UserDec["passWord"] = nil
            UserDec["pic"] = nil
            //to remove from DB
            UserDec["MyNotifcation"] = [:]
            UserDec["DOB"] = [:]
            UserDec["didVol"] = [:]
            UserDec["experians"] = [:]
            UserDec["interests"] = [:]
            UserDec["rate"] = [:]
            UserDec["subEvents"] = [:]
            UserDec["volEvents"] = [:]

            if UID != ""{
                Ref.child("Users/\(UID)").updateChildValues(UserDec,withCompletionBlock: { (error, ref) in
                    if (error != nil) {
                        onError()
                    }else{
                        onSucces()
                        //delert the requst
                        self.Ref.child("ImprovrToEMReq/\(UID)").removeValue()
                    }
                })
            }else{
                onError()
            }
    
        }
       
        
        
        //notifcation
        if let EMID = newUserObj.UID {
            addNtfAcceptedToBeEMReq(newEMUID: EMID)

        }
    }
    
    func acceptNewEMUserReq(UID:String,onSucces: @escaping () -> Void, onError: @escaping () -> Void){
        let newStaus:[String:Bool] = ["status":true]
        
        Ref.child("Users/\(UID)").updateChildValues(newStaus,withCompletionBlock: { (error, ref) in
            if (error != nil) {
                onError()
            }else{
                onSucces()
            }
        })

        //notifcation
        if let EMID = UID as? String {
            addNtfAcceptedToBeEMReq(newEMUID: EMID)
            
        }
    }
    
    //[#] Notifcations FB Methods -----
    func clearNotfcation(){
        if let UID = currnetUser.UID{
            if UID != ""{
                Ref.child("Users/\(UID)/MyNotifcation").removeValue()
            }
        }
    }
    //normal-user norifcations
    func addNtfToAllUsersMatchInterests(EID:String,EveInterests:[String]){
        let ntf:[String:String] = ["\(EID)":"matchs Yuor Interests"] as! [String:String]
        
        for userObj in allUsersGlobalArry{
            if let user = userObj as? normalUser{
                if let userInterests = user.intrests{
                    for EvetIntr in EveInterests{
                        for userIntr in userInterests{
                            if userIntr == EvetIntr{
                                self.Ref.child("Users/\(user.UID!)/MyNotifcation").updateChildValues(ntf)
                            }
                        }
                    }
                }// 3
            }//end if
            
        }// 1
        
    }
    func addNtfAcceptedToVolForVolUser(EID:String,VolUID:String){
        let ntf:[String:String] = ["\(EID)":"You've been accepted to volunteer"] as! [String:String]
        if VolUID != ""{
            self.Ref.child("Users/\(VolUID)/MyNotifcation").updateChildValues(ntf)
        }
        
    }
    func addNtfRejectedToVolForVolUser(EID:String,VolUID:String){
        let ntf:[String:String] = ["\(EID)":"You've been Rejected to volunteer"] as! [String:String]
        if VolUID != ""{
            self.Ref.child("Users/\(VolUID)/MyNotifcation").updateChildValues(ntf)
        }
    }
    func addNtfAcceptedToBeEMReq(newEMUID:String){
        let ntf:[String:String] = ["\(newEMUID)":"Your Requeset have been accepted to be an event manager"] as! [String:String]
        if newEMUID != ""{
            self.Ref.child("Users/\(newEMUID)/MyNotifcation").updateChildValues(ntf)
        }
    }
    //event-manager norifcations
    func addNtfVolReqInEveToEM(VolUID:String,EMUID:String){ //ntf to EM from vols
        let ntf:[String:String] = ["\(VolUID)":" new volunteer Requeset "] as! [String:String]
        if EMUID != "" && VolUID != ""{
            self.Ref.child("Users/\(EMUID)/MyNotifcation").updateChildValues(ntf)
        }
    }
    
    
    // Start of private helping functions ****
    
    private func genrateDecForEveObbj(EveObj:Event) -> [String:Any]{
        var EventDect:[String:Any] = [:]

        if  let EventID:String = EveObj.EID,
            let EventName:String = EveObj.EventName as? String,
            let attendenceType:String = EveObj.AttendenceType as? String,
            let EventDescription:String = EveObj.EventDescription as? String,
            let EventImageURLString:String = EveObj.EventImageURL as? String,
            let EventManagerID:String = EveObj.EventManagerID as? String,
            let timeObj:time = EveObj.EventTime as? time,
                let fromTimeHH:String = timeObj._fromTimeHH as? String,
                let fromTimeMM:String = timeObj._fromTimeMM as? String,
                let toTimeHH:String = timeObj._toTimeHH as? String,
                let toTimeMM:String = timeObj._toTimeMM as? String,
            let FromdateObj:date = EveObj.EventFDate as? date,

                let FromdateDay:Int = FromdateObj._D as? Int,
                let FromdateMonth:String = FromdateObj._M as? String,
                let FromdateYear:Int = FromdateObj._Y as? Int,
            let EnddateObj:date = EveObj.EventEDate as? date,

                let TodateDay:Int = EnddateObj._D as? Int,
                let TodateMonth:String = EnddateObj._M as? String,
                let TodateYear:Int = EnddateObj._Y as? Int,
            let EventLatitude:Double = EveObj.Eventlatitude as? Double,
            let EventLongitude:Double = EveObj.Eventlongitude as? Double,
            let needVol:Bool = EveObj.NeedVol as? Bool
            
        {
            //EventInterests
            var EventInterests:[String:String] = [:]
            if let Interests:[String] = EveObj.EventIntrests as? [String]{
                for Interest in Interests{
                    EventInterests[Interest] = Interest
                }
            }

            
            //time,date
        var EventTimeDect:[String:Any] = [:]
        var EventDateDect:[String:Any] = [:]

        EventTimeDect = [
            "fromTimeHH" : fromTimeHH,
            "fromTimeMM" : fromTimeMM,
            "toTimeHH" : toTimeHH,
            "toTimeMM" : toTimeMM
            ] as [String:Any]
            
        EventDateDect = [
            "FromdateDay" : FromdateDay,
            "FromdateMonth" : FromdateMonth,
            "FromdateYear" : FromdateYear,
            "TodateDay" : TodateDay,
            "TodateMonth" : TodateMonth,
            "TodateYear" : TodateYear
            ] as [String:Any]
        
        EventDect = [
            "EventName": EventName,
            "AttendenceType": attendenceType,
            "EventDescription": EventDescription,
            "EventImage": EventImageURLString,
            "EventManagerID": EventManagerID,
            "EventTime" : EventTimeDect,
            "EventDate": EventDateDect,
            "PostedDate": [".sv": "timestamp"],
            "Elatitude": EventLatitude,
            "Elongitude": EventLongitude,
            "needVol": needVol,
            "EventInterests" : EventInterests
            ] as [String:Any]

            return EventDect
        }
        return [:]
    }
    
    private func creatUserObj(UID: String, picURL: String, uType: String, uEmail: String, uPhone: String, uPassword: String,name:String,intrests: [String],uStatus:Bool,address:String,DOB:date,city:String,experians:String,numrRates:Int,totalRate:Double,didVol:Bool) -> userGeneral{
        
        let UserTpey:String = uType
        var UserObj = userGeneral.init(UID: "",picURL:"", uType: "", uEmail: "", uPhone: "", uPassword: "",uStatus: false)
        
        switch UserTpey{
            
        case (userGeneral.getEMStrFormat()) :// eventManager
            UserObj = eventManager.init(UID: UID, picURL: picURL, uType: uType, uEmail: uEmail, uPhone: uPhone, uPassword: uPassword,uStatus: uStatus, name: name, address: address, MyEvents: [], city : city,MyNotifcation:[])
            break
            
        case (userGeneral.getNUStrFormat()) : // normalUser
            UserObj = normalUser.init(UID: UID, picURL: picURL, uType: uType, uEmail: uEmail, uPhone: uPhone, uPassword: uPassword,uStatus: uStatus, name: name, intrests: intrests, subEvents: [], DOB: DOB, city: city, experians: experians, numrRates: numrRates, totalRate: totalRate,didVol:didVol,MyNotifcation:[])
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
            
            
            var intrestDec:[String:String] = [:]
            if let interstsArr = NU.intrests{
                for i in 0..<interstsArr.count{
                    intrestDec[interstsArr[i]] = interstsArr[i]
                }
            }
            
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
                "rate": ["numRates": NU.numrRates, "totalRate": NU.totalRate],
                "didVol": NU.didVol,
                "interests": intrestDec
                
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
    
    private func genrateEveObbjFromDec(EveDec:[String:Any],EID:String) -> Event{
        if  let EventID:String = EID,
            let EventName:String = EveDec["EventName"] as? String,
            let attendenceType:String = EveDec["AttendenceType"] as? String,
            let EventDescription:String = EveDec["EventDescription"] as? String,
            let EventImageURLString:String = EveDec["EventImage"] as? String,
            let EventManagerID:String = EveDec["EventManagerID"] as? String,
            let timeDect:[String:Any] = EveDec["EventTime"] as? [String:Any],
                let fromTimeHH:String = timeDect["fromTimeHH"] as? String,
                let fromTimeMM:String = timeDect["fromTimeMM"] as? String,
                let toTimeHH:String = timeDect["toTimeHH"] as? String,
                let toTimeMM:String = timeDect["toTimeMM"] as? String,
            let dateDect:[String:Any] = EveDec["EventDate"] as? [String:Any],
                let FdateDay:Int = dateDect["FromdateDay"] as? Int,
                let FdateMonth:String = dateDect["FromdateMonth"] as? String,
                let FdateYear:Int = dateDect["FromdateYear"] as? Int,
                let TdateDay:Int = dateDect["TodateDay"] as? Int,
                let TdateMonth:String = dateDect["TodateMonth"] as? String,
                let TdateYear:Int = dateDect["TodateYear"] as? Int,
            let EventLatitude:Double = EveDec["Elatitude"] as? Double,
            let EventLongitude:Double = EveDec["Elongitude"] as? Double,
            let needVol:Bool = EveDec["needVol"] as? Bool
        {
            
            var EveInterests:[String] = []
            
            if let EveInt:[String:String] = EveDec["EventInterests"] as? [String:String]{
                for Interest in EveInt{
                    EveInterests.append(Interest.value)
                }
            }
            

            let ET:time = time.init(fromTimeHH: fromTimeHH, fromTimeMM: fromTimeMM, toTimeHH: toTimeHH, toTimeMM: toTimeMM)
            
            let FD:date = date.init(D: FdateDay, M: FdateMonth, Y: FdateYear)
            let ED:date = date.init(D: TdateDay, M: TdateMonth, Y: TdateYear)
            
            return Event.init(EID: EventID,EventNameTxt: EventName, AttendenceTypeTxt: attendenceType, EventDescriptionTxt: EventDescription, EventImageURLString: EventImageURLString,EveIntrests:EveInterests, EMID: EventManagerID, ET: ET, FD: FD, ED: ED, Elatitude: EventLatitude, Elongitude: EventLongitude, needVol:needVol)
            


        }
        
        EventorTesting.EvntorTestObj.WarningTestMsgFor(testKeySymbol: "t", funcName: "genrateEveObbjFromDec", inFileName: "FBDBHanldeler", testingVersion: 1, testerName: "Yazeed", testerMsg: "Event obj not genrated after getting info from FBDB!! and this happed coz the the info i'm looking for in the DB in NOT (ALL) thers so i can't creat the object!")
        print("Event obj not genrated after getting info from FBDB!! and this happed coz the the info i'm looking for in the DB in NOT (ALL) thers so i can't creat the object!")
        return Event.init()
    }
    
    private func genrateUserObbjFromDec(UserDec:[String:Any],UID:String) -> userGeneral{
        if let UserTpey:String = UserDec["UType"] as? String,
            let picURL:String = UserDec["pic"] as? String,
            let Uemail:String = UserDec["Email"] as? String,
            let UPhone:String = UserDec["Phone"] as? String,
            let UPW:String = UserDec["passWord"] as? String,
            let status:Bool = UserDec["status"] as? Bool {
            
            print("myUser SnapShot:")
            print(UserDec)
            
            var MyNotification:[Notication] = []
            if let ntfsDec:[String:String] = UserDec["MyNotifcation"] as? [String:String]{
                print("dec genrated!")
                for ntf in ntfsDec{
                    
                    if  let ID = ntf.key  as? String , let NTF = ntf.value as? String {
                        print("key,val genrated!")

                        let NtfObj:Notication = Notication(UOREid: ID , Ntf: NTF )
                        MyNotification.append(NtfObj)
                    }
                }
            }
            print("MyNotification arr")

            print(MyNotification)
            switch UserTpey {
                
            case (userGeneral.getEMStrFormat()) :// eventManager
                if let EMName:String = UserDec["name"] as? String,
                    let EMCity:String = UserDec["city"] as? String,
                    let EMAddress:String = UserDec["address"] as? String{
                    
                    return eventManager.init(UID: UID,picURL:picURL, uType: UserTpey, uEmail: Uemail, uPhone: UPhone, uPassword: UPW,uStatus: status, name: EMName, address: EMAddress, MyEvents: [],city:EMCity,MyNotifcation:MyNotification)
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
                    let totalRate:Double = RateDec["totalRate"] as? Double,
                    let didVol:Bool = UserDec["didVol"] as? Bool
                    
                {
                    
                    var  intrestsArr:[String] = []
                    if let interestsDec = UserDec["interests"] as? [String:String]{
                        for interest in interestsDec{
                            intrestsArr.append(interest.value)
                        }
                    }
                    
                    let DOB = date.init(D: D, M: M, Y: Y)

                    return normalUser.init(UID: UID,picURL:picURL, uType: UserTpey, uEmail: Uemail, uPhone: UPhone, uPassword: UPW,uStatus: status, name: NUName, intrests: intrestsArr, subEvents: [],DOB:DOB,city: NUCity, experians: NUExp, numrRates: numRates, totalRate: totalRate,didVol:didVol,MyNotifcation:MyNotification)

                }
                break
            
            case (userGeneral.getAdminStrFormat()) : // admin
                return admin.init(UID: UID,picURL:picURL, uType: UserTpey, uEmail: Uemail, uPhone: UPhone, uPassword: UPW,uStatus: status)
                break
            default: break
                
            }//end switch
        }
        
        EventorTesting.EvntorTestObj.WarningTestMsgFor(testKeySymbol: "t", funcName: "genrateUserObbjFromDec", inFileName: "FBDBHanldeler", testingVersion: 1, testerName: "Yazeed", testerMsg: "user obj not genrated after getting info from FBDB!! and this happed coz the the info i'm looking for in the DB in NOT (ALL) thers so i can't creat the object!")
        
        print("user obj not genrated after getting info from FBDB!! and this happed coz the the info i'm looking for in the DB in NOT (ALL) thers so i can't creat the object!")
        return userGeneral.init(UID: "",picURL:"", uType: "", uEmail: "", uPhone: "", uPassword: "",uStatus: false)
    }
}
