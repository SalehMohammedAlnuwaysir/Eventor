//
//  AdminVC.swift
//  Eventor
//
//  Created by Saud Alkahtani on 03/08/1440 AH.
//  Copyright © 1440 Eventor. All rights reserved.
//

import UIKit

class AdminVC: UIViewController {
    
    @IBOutlet weak var totalEveLbl: UILabel!
    @IBOutlet weak var totalUserLbl: UILabel!
    var startVC:startVC? = nil
    var usersArrWithOutMe:[userGeneral] = []
    var EventsArr:[Event] = []
    var EMReqsNotAcceptdYet:[userGeneral] = []
    var upgdareToEMReqsNotAcceptdYet:[userGeneral] = []


    @IBOutlet weak var eveToSponseorView: UIView!
    @IBOutlet weak var eveNotToSponseorView: UIView!
    @IBOutlet weak var EMsUserView: UIView!
    @IBOutlet weak var NUsUserView: UIView!

    @IBOutlet weak var eveToSponseorLbl: UILabel!
    @IBOutlet weak var eveNotToSponseorLbl: UILabel!
    @IBOutlet weak var EMsUserLbl: UILabel!
    @IBOutlet weak var NUsUserLbl: UILabel!
    
    //users-events popupView
    @IBOutlet weak var deleteUsreOrEventView:UIView!
    @IBOutlet weak var DUOEtableView: UITableView!
    @IBOutlet weak var DUOEcloseBtn:UIButton!
    
    


    var numOfEvesNotToSponseor = 0
    var numOfEveToSponseor = 0
    var numOfEMs = 0
    var numOfNUs = 0
    
    var whatToView = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        HindeKeyboardViewTouched()
        self.DUOEtableView.delegate = self
        self.DUOEtableView.dataSource = self
        updatePageInfo()
        psitionView()
        // Do any additional setup after loading the view.
    }
    
    func updatePageInfo(){
        
        usersArrWithOutMe = userGeneral.getUsersWithOutCurrent()
        EventsArr = allEventsGlobalArry
        EMReqsNotAcceptdYet = userGeneral.getAllEMReqsNotAcceptdYet()
        upgdareToEMReqsNotAcceptdYet = userGeneral.getAllNUTobeEMReqsNotAcceptdYet()
        numOfEvesNotToSponseor = Event.getNumOfEveNotToSponsor()
        numOfEveToSponseor = Event.getNumOfEveToSponsor()
        numOfEMs = userGeneral.getNumOfEMUsers()
        numOfNUs = userGeneral.getNumOfNUsers()
        
        updateStatiscicsView()
        
        //end
        DUOEtableView.reloadData()

    }
    
    
    func psitionView(){
        let MainViewCenter = self.view.center
        let MainViewHight = self.view.frame.height
        let MainViewWidth = self.view.frame.width
        deleteUsreOrEventView.frame.size = CGSize(width: MainViewWidth, height: MainViewHight)
        deleteUsreOrEventView.center = MainViewCenter

    }
    
    @IBAction func logOutBtnressed(_ sender:Any){
        FBDBHandler.FBDBHandlerObj.signOut()
       
        self.dismiss(animated: true, completion: {
            if self.startVC != nil {
                self.startVC?.viewDidLoad()
            }
        })
        
    }
    
    @IBAction func DUOEclosetnPresed(_ sender:Any){
        self.closePupView(popupView: deleteUsreOrEventView)
    }
    
    
    @IBAction func ShowEMReqsBtnPressed(_ sender:Any){
        refrishingHanler.refrishingHanlerObj.startRefrising(view: self.view)
        FBDBHandler.FBDBHandlerObj.loadUsers(onSucces: {
            self.whatToView = "EMreqs"
            self.updatePageInfo() // will reload table too

            self.showPupView(popupView: self.deleteUsreOrEventView)
            refrishingHanler.refrishingHanlerObj.endRefrising(view: self.view)
            
            //self.view.addSubview(self.DUOEtableView)
        }, onError: {_ in
            self.whatToView = ""
            notificationHelper.notificationHelperObj.showError(callerVC: self, Err: "err happend!", color: .red)
            refrishingHanler.refrishingHanlerObj.endRefrising(view: self.view)
            
        })
    }
    
    @IBAction func ShowEMUpgradeReqsBtnPressed(_ sender:Any){
        refrishingHanler.refrishingHanlerObj.startRefrising(view: self.view)
        FBDBHandler.FBDBHandlerObj.loedNUReqTobeEM(completion: {
            
            self.whatToView = "upgradeToEMreqs"
            self.updatePageInfo()//will reload table too
            
            self.showPupView(popupView: self.deleteUsreOrEventView)
            refrishingHanler.refrishingHanlerObj.endRefrising(view: self.view)
            
        })
        refrishingHanler.refrishingHanlerObj.endRefrising(view: self.view)

    }
    
    @IBAction func ShowEventsBtnPressed(_ sender: Any) {
        
        refrishingHanler.refrishingHanlerObj.startRefrising(view: self.view)
        FBDBHandler.FBDBHandlerObj.loadEves(onSucces: {
            self.whatToView = "events"
            self.updatePageInfo()//will reload table too

            self.showPupView(popupView: self.deleteUsreOrEventView)
            refrishingHanler.refrishingHanlerObj.endRefrising(view: self.view)


        }, onError: {_ in
            self.whatToView = ""
            notificationHelper.notificationHelperObj.showError(callerVC: self, Err: "err happend!", color: .red)
            refrishingHanler.refrishingHanlerObj.endRefrising(view: self.view)


        })
    }
    
    func showPupView(popupView:UIView){
        self.view.addSubview(popupView)
    }
    
    
    func closePupView(popupView:UIView){
        popupView.removeFromSuperview()
    }
    
    
    @IBAction func ShowUsersBtnPressed(_ sender: Any) {
        refrishingHanler.refrishingHanlerObj.startRefrising(view: self.view)
        FBDBHandler.FBDBHandlerObj.loadUsers(onSucces: {
            self.whatToView = "users"
            self.updatePageInfo()//will reload table too

            self.showPupView(popupView: self.deleteUsreOrEventView)
            refrishingHanler.refrishingHanlerObj.endRefrising(view: self.view)

            //self.view.addSubview(self.DUOEtableView)
        }, onError: {_ in
            self.whatToView = ""
            notificationHelper.notificationHelperObj.showError(callerVC: self, Err: "err happend!", color: .red)
            refrishingHanler.refrishingHanlerObj.endRefrising(view: self.view)

        })
        
    }
    
    func deleteUser (_ uid: String) {
        refrishingHanler.refrishingHanlerObj.startRefrising(view: self.view)
        FBDBHandler.FBDBHandlerObj.deleteUser(UID: uid, onSucces: {
            self.updatePageInfo()
            self.DUOEclosetnPresed(self)
            notificationHelper.notificationHelperObj.showError(callerVC: self, Err: "User deleted!", color: .green)
            refrishingHanler.refrishingHanlerObj.endRefrising(view: self.view)

        }, onError: {
            notificationHelper.notificationHelperObj.showError(callerVC: self, Err: "err happend!", color: .red)
            refrishingHanler.refrishingHanlerObj.endRefrising(view: self.view)

        })
    }
   
    
    func deleteEvent(_ eid: String) {
        refrishingHanler.refrishingHanlerObj.startRefrising(view: self.view)
        FBDBHandler.FBDBHandlerObj.deleteEve(EID: eid, onSucces: {
            self.updatePageInfo()
            self.DUOEclosetnPresed(self)
            notificationHelper.notificationHelperObj.showError(callerVC: self, Err: "Event deleted!", color: .green)
            refrishingHanler.refrishingHanlerObj.endRefrising(view: self.view)

        }, onError: {
            notificationHelper.notificationHelperObj.showError(callerVC: self, Err: "err happend!", color: .red)
            refrishingHanler.refrishingHanlerObj.endRefrising(view: self.view)

        })
    }
    
    func acceptNewEMReq(_ eid: String){
        refrishingHanler.refrishingHanlerObj.startRefrising(view: self.view)
        FBDBHandler.FBDBHandlerObj.acceptNewEMUserReq(UID: eid, onSucces: {
            self.updatePageInfo()
            self.DUOEclosetnPresed(self)
            notificationHelper.notificationHelperObj.showError(callerVC: self, Err: "user accepted!", color: .green)
            refrishingHanler.refrishingHanlerObj.endRefrising(view: self.view)
            
        }, onError: {
            notificationHelper.notificationHelperObj.showError(callerVC: self, Err: "err happend!", color: .red)
            refrishingHanler.refrishingHanlerObj.endRefrising(view: self.view)
            
        })
    }
    
    func acceptNUToBeEMReq(_ eid: String,_ UserObj: userGeneral){
        refrishingHanler.refrishingHanlerObj.startRefrising(view: self.view)
        FBDBHandler.FBDBHandlerObj.acceptNUserToBeEMReq(UID: eid, newUserObj: UserObj, onSucces: {
            self.updatePageInfo()
            self.DUOEclosetnPresed(self)
            notificationHelper.notificationHelperObj.showError(callerVC: self, Err: "user accepted!", color: .green)
            refrishingHanler.refrishingHanlerObj.endRefrising(view: self.view)
            
        }, onError: {
            notificationHelper.notificationHelperObj.showError(callerVC: self, Err: "err happend!", color: .red)
            refrishingHanler.refrishingHanlerObj.endRefrising(view: self.view)
            
        })
    }
    
    func updateStatiscicsView(){
        
        totalEveLbl.text = "\(numOfEvesNotToSponseor+numOfEveToSponseor)"
        totalUserLbl.text = "\(numOfEMs+numOfNUs)"
        
        //Eve to sponsor
        changeStatViewSize(theView: eveToSponseorView, numOfPart: numOfEveToSponseor, numOfTotal: numOfEvesNotToSponseor+numOfEveToSponseor, lbl: eveToSponseorLbl, text: "need sponsor")

        //Eve not to sponsor
        changeStatViewSize(theView: eveNotToSponseorView, numOfPart: numOfEvesNotToSponseor, numOfTotal: numOfEvesNotToSponseor+numOfEveToSponseor, lbl: eveNotToSponseorLbl, text: "with sponsor")
        
        
        //EMs
        changeStatViewSize(theView: EMsUserView, numOfPart: numOfEMs, numOfTotal: numOfEMs+numOfNUs, lbl: EMsUserLbl, text: "Event-Managers")
        
        //NUs
        changeStatViewSize(theView: NUsUserView, numOfPart: numOfNUs, numOfTotal: numOfEMs+numOfNUs, lbl: NUsUserLbl, text: "Normal-Users")
        
    }
    
    func changeStatViewSize(theView:UIView,numOfPart:Int,numOfTotal:Int,lbl:UILabel,text:String){
        
        let perCenteg:Double = getPercenteg(part: numOfPart, total: numOfTotal)
       // let theViewNewWidth:CGFloat = theView.frame.width * CGFloat(perCenteg+1.0)
        
        //theView.transform = CGAffineTransform(translationX: 0.7, y: 0)
        UIView.animate(withDuration: 0.5, animations: {
            theView.transform = CGAffineTransform(scaleX: CGFloat(perCenteg+0.7), y: CGFloat(perCenteg+0.7))

           // theView.bounds = CGRect(x: theView.bounds.minX, y: theView.bounds.minY, width: theViewNewWidth , height: theView.bounds.height)
           // theView.frame.size = CGSize(width: theViewNewWidth, height: theView.frame.height)
            lbl.text = "\(Int(perCenteg*100.0))%\n\(text)\n[\(numOfPart)]"
        })
        
    }
    
    func getPercenteg(part:Int,total:Int) -> Double{
        if part > total || total == 0{
            return 0.0

        }else{
            let Total:Double = Double(total)
            let Part:Double = Double(part)
            //part over total
            //->to get the persenteg of the part from the total
            //will be  between [0.0 ... 1.0]
            return (Part/Total)
        }
    }
    
    
}

extension AdminVC: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if whatToView == "users"{
            return usersArrWithOutMe.count
        }else if whatToView == "events"{
            return EventsArr.count
        }else if  whatToView == "EMreqs"{
            return EMReqsNotAcceptdYet.count
        }else if  whatToView == "upgradeToEMreqs"{
            return upgdareToEMReqsNotAcceptdYet.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersForAdminCell", for: indexPath) as! UsersForAdminCell
        
        if whatToView == "users" && indexPath.row < usersArrWithOutMe.count{
            cell.UserNameLbl?.text = usersArrWithOutMe[indexPath.row].uEmail
            cell.subLbl?.text = "UID: \(usersArrWithOutMe[indexPath.row].UID!)"
            //cell.btn.imageView?.image = UIImage(named: "delete")
            
        } else if whatToView == "events" && indexPath.row < EventsArr.count{
            cell.UserNameLbl?.text = EventsArr[indexPath.row].EventName
            cell.subLbl?.text = "EID: \(EventsArr[indexPath.row].EID!)"
           // cell.btn.imageView?.image = UIImage(named: "delete")


        } else if  whatToView == "EMreqs" && indexPath.row < EMReqsNotAcceptdYet.count{
            cell.UserNameLbl?.text = EMReqsNotAcceptdYet[indexPath.row].uEmail
            cell.subLbl?.text = "UID: \(EMReqsNotAcceptdYet[indexPath.row].UID!)"
           // cell.btn.imageView?.image = UIImage(named: "Show")

            
        } else if  whatToView == "upgradeToEMreqs" && indexPath.row < upgdareToEMReqsNotAcceptdYet.count{
            cell.UserNameLbl?.text = upgdareToEMReqsNotAcceptdYet[indexPath.row].uEmail
            cell.subLbl?.text = "UID: \(upgdareToEMReqsNotAcceptdYet[indexPath.row].UID!)"
           // cell.btn.imageView?.image = UIImage(named: "Show")

        }

        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var message = "default test"
        var title = "default title test"
        
        if self.whatToView == "users"{
        title = "Are you sure you want to delete \(usersArrWithOutMe[indexPath.row].uEmail!)"
         message = "If he is an event manager, all of his events will be deleted"
            
        } else if self.whatToView == "events" {
             title = "Are you sure you want to delete \(EventsArr[indexPath.row].EventName!)"
             message = "The event will be deleted with all of its Subscribed users!"
        }else if  whatToView == "EMreqs"{
            title = "Are you sure you want to accept \(EMReqsNotAcceptdYet[indexPath.row].uEmail!)"
            message = ""
        }else if  whatToView == "upgradeToEMreqs"{
            title = "Are you sure you want to accept \(upgdareToEMReqsNotAcceptdYet[indexPath.row].uEmail!)"
            message = ""
        }

        
        
        
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.destructive, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            print ("No")
        }))
        
        
        
        //action Of the alert
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            
           
            if self.whatToView == "users"{
                self.deleteUser(self.usersArrWithOutMe[indexPath.row].UID)
            }else if self.whatToView == "events"{
                self.deleteEvent(self.EventsArr[indexPath.row].EID)
            }else if  self.whatToView == "EMreqs"{
                self.acceptNewEMReq(self.EMReqsNotAcceptdYet[indexPath.row].UID)
            }else if  self.whatToView == "upgradeToEMreqs"{
                self.acceptNUToBeEMReq(self.upgdareToEMReqsNotAcceptdYet[indexPath.row].UID, self.upgdareToEMReqsNotAcceptdYet[indexPath.row])
            }
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}

