//
//  showEvntsVC.swift
//  Eventor
//
//  Created by YAZEED NASSER on 26/03/2019.
//  Copyright © 2019 Eventor. All rights reserved.
//

import UIKit

class showEvntsListVC: UIViewController{

    @IBOutlet weak var nav:UINavigationBar!
    @IBOutlet weak var EventsTableView:UITableView!
    var isItToSponsor:Bool = false
    var refresher: UIRefreshControl!

    
    var ViewTitle: String!
    var Events:[Event]!{
        didSet{
            updateView()
        }
    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HindeKeyboardViewTouched()
        //change the nav titel
        self.title = ViewTitle
        
        //for refreshe
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Drag to refrish")
        refresher.addTarget(self, action: #selector(refrishInfo), for: UIControl.Event.valueChanged )
        EventsTableView?.addSubview(refresher)
        
        EventsTableView?.reloadData()


        // Do any additional setup after loading the view.
    }
    
    func updateView(){
        print(Events.count)
        print(Events)
        viewDidLoad()
    }
    
    @objc func refrishInfo(){
        if FBDBHandler.FBDBHandlerObj.checkInternet(VC:self){
            
            FBDBHandler.FBDBHandlerObj.loadEves(onSucces: {
                FBDBHandler.FBDBHandlerObj.loadMyUser(UID: currnetUser.UID, onSucces: {
                    self.refresher.endRefreshing()
                })
            }, onError: {_ in
                self.refresher.endRefreshing()
                notificationHelper.notificationHelperObj.showError(callerVC: self, Err: "error happened", color: .red)

            })}
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension showEvntsListVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Events.count != 0 {
           return Events.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if Events.count != 0 {
            print("ggg")
            let cell = EventsTableView.dequeueReusableCell(withIdentifier: "EventTVCell", for: indexPath) as! EventTVCell
            cell.showSponsorBtn = isItToSponsor
            cell.EveObj = Events[indexPath.row]
            cell.mainVC = self
            cell.selectionStyle = .none
            return cell
        }
        return  EventsTableView.dequeueReusableCell(withIdentifier: "noEventsCell", for: indexPath)

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let VC = storyboard?.instantiateViewController(withIdentifier: "ViewEventVC") as? ViewEventVC
        
        if indexPath.row < Events.count {
            let eachEvent = Events[indexPath.row]
            VC?.EveHolder = eachEvent
            self.navigationController?.pushViewController(VC!, animated: true)

        }
        
    }
    
    
}
