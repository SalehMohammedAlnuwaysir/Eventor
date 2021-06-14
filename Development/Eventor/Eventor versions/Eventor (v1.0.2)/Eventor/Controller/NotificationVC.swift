//
//  NotificationVC.swift
//  Eventor
//
//  Created by Saleh on 19/05/1440 AH.
//  Copyright © 1440 Eventor. All rights reserved.
//

import UIKit

class NotificationVC: UIViewController {

    @IBOutlet weak var notifcationTV:UITableView!
    var whatToView = ""
    var notfications:[Notication] = []
    var refresher: UIRefreshControl!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HindeKeyboardViewTouched()
        
        self.notifcationTV.delegate = self
        self.notifcationTV.dataSource = self
        
        //for refreshe
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Drag to refrish")
        refresher.addTarget(self, action: #selector(refrishInfo), for: UIControl.Event.valueChanged )
        notifcationTV.addSubview(refresher)
        
        refrishInfo()
    }

    
    @objc func refrishInfo(){
        if FBDBHandler.FBDBHandlerObj.checkInternet(VC:self){
            
            FBDBHandler.FBDBHandlerObj.loadEves(onSucces: {
                FBDBHandler.FBDBHandlerObj.loadMyUser(UID: currnetUser.UID, onSucces: {
                   self.updateView()
                    self.refresher.endRefreshing()
                    
                })
            }, onError: {_ in
                self.refresher.endRefreshing()
                notificationHelper.notificationHelperObj.showError(callerVC: self, Err: "error happened", color: .red)
                
            })}
        
    }
    
    func updateView(){
        whatToView = ""
        if currnetUser.uType == userGeneral.getNUStrFormat(){
            whatToView = "NUNtf"
            if let ntfArr = (currnetUser as! normalUser).MyNotifcation{
                notfications = ntfArr
            }
            
        }else if currnetUser.uType == userGeneral.getEMStrFormat(){
            whatToView = "EMNtf"
            if let ntfArr = (currnetUser as! eventManager).MyNotifcation{
                notfications = ntfArr
            }
        }
        
        
        notifcationTV.reloadData()
    }
    
    @IBAction func clearBtnPressed(_ sender:Any){
        FBDBHandler.FBDBHandlerObj.clearNotfcation()
        
        if currnetUser.uType == userGeneral.getNUStrFormat(){
            (currnetUser as! normalUser).MyNotifcation = []
           
        }else if currnetUser.uType == userGeneral.getEMStrFormat(){
            (currnetUser as! eventManager).MyNotifcation = []
        }
        
        updateView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension NotificationVC: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("**********************************")

        print(notfications.count)
        if notfications.count == 0{
            return 1
        }
            return notfications.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ntfCell", for: indexPath) as! ntfCell
        if notfications.count == 0{
            cell.Titel.text = "nothing found!"
            cell.Ntf.text = ""

            return cell

        }
        
        if whatToView == "NUNtf"{
            let EID = notfications[indexPath.row].UOREid
            let Ntf = notfications[indexPath.row].Ntf
            
            cell.Titel.text = "\(Event.getEveByIDFromGolbEveArry(EID: EID).EventName!) Event"
            cell.Ntf.text = "\(Ntf)"
            
        } else if whatToView == "EMNtf" {
            
            let UID = notfications[indexPath.row].UOREid
            var userNameTxtIfTher = "user name cuoldn't be found!"
            if let user = userGeneral.getUserObjBy(UID: UID) as? normalUser{
                userNameTxtIfTher = user.name
            }
            
            
            let Ntf = notfications[indexPath.row].Ntf
            
            cell.Titel.text = "\(userNameTxtIfTher) has"
            cell.Ntf.text = "\(Ntf)"
            
        }
        
        return cell
    }
    

}

