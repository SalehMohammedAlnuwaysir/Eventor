//
//  HomeVC.swift
//  Eventor
//
//  Created by Saleh on 19/05/1440 AH.
//  Copyright © 1440 Eventor. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class HomeVC: UIViewController, UISearchBarDelegate {
    
    var FirebaseStorage: Storage?
    var events = [Event]()
    var myEvents = [String]()
    var returnCell: String = "events"
    
    @IBOutlet weak var createBtn: UIButton!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var FilterView: UIView!
    
    @IBOutlet weak var attendenceTypeSeg: UISegmentedControl!
    var attendenceTypeSegment: String!
    
    var EventManagerProfileImage = ""
    var EventManagerName = ""
    
    var searchTxtVal = ""
    @IBOutlet weak var searchBar: UISearchBar!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var refresher: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createBtn.isHidden = true
        filterBtn.isHidden = true
        
        if (Auth.auth().currentUser == nil) {
            performSegue(withIdentifier: "notRegisteredUser", sender: nil)
        } else {
            FBDBHandler.FBDBHandlerObj.loadMyUser(UID: (Auth.auth().currentUser?.uid)!, onSucces:{})
            Database.database().reference().child("Users").child((Auth.auth().currentUser?.uid)!).child("UType").observe(.value, with: { (snapshot) in
                if let value = snapshot.value as? String {
                    if (value == "eventManager") {
                        self.createBtn.isHidden = false
                    }
                }
            })
        }
        
        activityIndicator.transform = CGAffineTransform(scaleX: 1.7, y: 1.7)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(HomeVC.loadEvents), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)

        tableView.dataSource = self
        loadEvents()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func loadEvents() {
        events = []
        Database.database().reference().child("Events").queryOrdered(byChild: "PostedDate").observe(.childAdded) { (snapshot: DataSnapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let EventName = dict["EventName"] as! String
                let AttendenceType = dict["AttendenceType"] as! String
                let EventDescription = dict["EventDescription"] as! String
                let EventImage = dict["EventImage"] as! String
                let EventManager = dict["EventManagerID"] as! String
                let EventFromTime = dict["EventFromTime"] as! String
                let EventToTime = dict["EventToTime"] as! String
                let EventDate = dict["EventDate"] as! String

                let EventLatitude = dict["Elatitude"] as! Double
                let EventLongitude = dict["Elongitude"] as! Double
                let event = Event(EventNameTxt: EventName, AttendenceTypeTxt: AttendenceType, EventDescriptionTxt: EventDescription, EventImageURLString: EventImage, EMID: EventManager, EFT: EventFromTime, ETT: EventToTime, ED: EventDate, Elatitude: EventLatitude, Elongitude: EventLongitude, postedDate: "Date")
                self.events.append(event)
                self.refresher.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) { //search
        view.endEditing(true)
        events = []
        searchTxtVal = searchBar.text!
        Database.database().reference().child("Events").queryOrdered(byChild: "PostedDate").observe(.childAdded) { (snapshot: DataSnapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let EventName = dict["EventName"] as! String
                if (EventName.localizedStandardContains(self.searchTxtVal)) {
                    self.filterBtn.isHidden = false
                    let AttendenceType = dict["AttendenceType"] as! String
                    let EventDescription = dict["EventDescription"] as! String
                    let EventImage = dict["EventImage"] as! String
                    let EventManager = dict["EventManagerID"] as! String
                    let EventFromTime = dict["EventFromTime"] as! String
                    let EventToTime = dict["EventToTime"] as! String
                    let EventDate = dict["EventDate"] as! String

                    let EventLatitude = dict["Elatitude"] as! Double
                    let EventLongitude = dict["Elongitude"] as! Double
                    let event = Event(EventNameTxt: EventName, AttendenceTypeTxt: AttendenceType, EventDescriptionTxt: EventDescription, EventImageURLString: EventImage, EMID: EventManager, EFT: EventFromTime, ETT: EventToTime, ED: EventDate, Elatitude: EventLatitude, Elongitude: EventLongitude, postedDate: "Date")
                    self.events.append(event)
                    self.tableView.reloadData()
                } else {
                    self.filterBtn.isHidden = true
                    self.events = []
                    self.tableView.reloadData()
                    let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
                    noDataLabel.text          = "Nothing match your search"
                    noDataLabel.textColor     = UIColor.darkGray
                    noDataLabel.textAlignment = .center
                    self.tableView.backgroundView  = noDataLabel
                    self.tableView.separatorStyle  = .none
                }
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filterBtn.isHidden = true
        view.endEditing(true)
        searchBar.text = ""
        loadEvents()
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        self.FilterView.removeFromSuperview()
    }
    
    @IBAction func filterBtnPressed(_ sender: Any) {
        self.FilterView.frame.size = self.view.frame.size
        self.view.addSubview(self.FilterView)
        self.FilterView.center = self.view.center
    }
    
    @IBAction func attendenceTypeSeg(_ sender: UISegmentedControl) {
        attendenceTypeSegment = sender.titleForSegment(at: sender.selectedSegmentIndex)
    }
    
    @IBAction func applyBtnPressed(_ sender: Any) { //Filter
        view.endEditing(true)
        events = []
        searchTxtVal = searchBar.text!
        Database.database().reference().child("Events").queryOrdered(byChild: "PostedDate").observe(.childAdded) { (snapshot: DataSnapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let EventName = dict["EventName"] as! String
                let AttendenceType = dict["AttendenceType"] as! String
                if (EventName.localizedStandardContains(self.searchTxtVal) && AttendenceType == self.attendenceTypeSegment) {
                    self.filterBtn.isHidden = false
                    let EventDescription = dict["EventDescription"] as! String
                    let EventImage = dict["EventImage"] as! String
                    let EventManager = dict["EventManagerID"] as! String
                    let EventFromTime = dict["EventFromTime"] as! String
                    let EventToTime = dict["EventToTime"] as! String
                    let EventDate = dict["EventDate"] as! String
                    let EventLatitude = dict["Elatitude"] as! Double
                    let EventLongitude = dict["Elongitude"] as! Double
                    let event = Event(EventNameTxt: EventName, AttendenceTypeTxt: AttendenceType, EventDescriptionTxt: EventDescription, EventImageURLString: EventImage, EMID: EventManager, EFT: EventFromTime, ETT: EventToTime, ED: EventDate, Elatitude: EventLatitude, Elongitude: EventLongitude, postedDate: "Date")
                    self.events.append(event)
                    self.tableView.reloadData()
                } else {
                    self.events = []
                    self.tableView.reloadData()
                    let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
                    noDataLabel.text          = "Nothing match your search"
                    noDataLabel.textColor     = UIColor.darkGray
                    noDataLabel.textAlignment = .center
                    self.tableView.backgroundView  = noDataLabel
                    self.tableView.separatorStyle  = .none
                }
            }
        }
        self.FilterView.removeFromSuperview()
    }
    
    @IBAction func removeFilterBtnPressed(_ sender: Any) {
        searchBarSearchButtonClicked(self.searchBar)
        self.FilterView.removeFromSuperview()
    }
    
    @IBAction func createBtnPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "createEvent", sender: nil)
    }
}

extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var num: Int = 0
        if (events.count != 0) {
            tableView.separatorStyle = .singleLine
            num            = events.count
            tableView.backgroundView = nil
        } else {
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = ""
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return num
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        activityIndicator.stopAnimating()
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! HomeTvCell
        if(returnCell == "events"){
            let eachEvent = events.reversed()[indexPath.row]
            
            cell.dateView.layer.cornerRadius = 5
            cell.dateView.layer.masksToBounds = true
            cell.EventName.text = eachEvent.EventName
            cell.AttendenceType.text = eachEvent.AttendenceType
            cell.Time.text = "\(eachEvent.EventFromTime)-\(eachEvent.EventToTime)"
            cell.yearLbl.text = eachEvent.EventDate
            
            //cell.EventImage.loadImageURLStringUsingCashe(StringURL: eachEvent.EventImageURL!)
            
            Database.database().reference().child("Users").child(eachEvent.EventManagerID).child("name").observe(.value, with: { (snapshot) in
                if let value = snapshot.value as? String {
                    cell.EventManagerName.text = value
                    self.EventManagerName = value
                }
            })
            return cell
        }
        
        // No match
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        let VC = storyboard?.instantiateViewController(withIdentifier: "ViewEventVC") as? ViewEventVC
        let eachEvent = events.reversed()[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        VC?.EventimageURL = eachEvent.EventImageURL!
        VC?.Description = "   \(eachEvent.EventDescription)"
        VC?.EventNameString = "   \(eachEvent.EventName)"
        VC?.profileImageURL = self.EventManagerProfileImage
        VC?.EventManagerName = self.EventManagerName
        VC?.EventattendenceType = eachEvent.AttendenceType
        VC?.EventTime = "\(eachEvent.EventFromTime)-\(eachEvent.EventToTime)"
        self.navigationController?.pushViewController(VC!, animated: true)
    }
}
