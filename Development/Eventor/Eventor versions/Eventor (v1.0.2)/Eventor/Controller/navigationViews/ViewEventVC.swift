//
//  ViewEventVC.swift
//  Eventor
//
//  Created by Saleh on 05/06/1440 AH.
//  Copyright © 1440 Eventor. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import MapKit
import CoreLocation

class ViewEventVC: UIViewController {
    var fromWhere: String!
    var EveHolder: Event?
    
    @IBOutlet weak var EventImage: UIImageView!
    @IBOutlet weak var EventDescription: UILabel!
    @IBOutlet weak var ShareButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var EMName: UILabel!
    @IBOutlet weak var EventName: UILabel!
    @IBOutlet weak var attendenceType: UILabel!
    @IBOutlet weak var Time: UILabel!
    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var SubscribersLbl: UILabel!
    @IBOutlet weak var viewOnMapBtn: RoundedBtn!
    @IBOutlet weak var subscribeBtn: UIButton!
    var checkIfTheCurrentUserAfterHeOrSheOpenedThisEventAlreadySubscribedForThisEventOrNot: Bool!
    @IBOutlet weak var VolunteerBtn: UIButton!
    
    @IBOutlet weak var EditBtn: UIBarButtonItem!
    @IBOutlet var EditView: UIView!
    @IBOutlet var VolunteerView: UIView!
    
    // Background view for popup views
    let BGPopupView:UIView = UIView.init(frame: CGRect.init())
    
    // View Image View
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet var VIView: UIView!
    @IBOutlet weak var VIImgView: UIImageView!
    
    // Volunteers list
    var whichTableView = 0
    var volunteers = [EvePerson]()
    var index: IndexPath?
    @IBOutlet weak var volunteersTableView: UITableView!
    @IBOutlet weak var tableViewSeg: UISegmentedControl!
    
    // View Map
    @IBOutlet var MapSubView: UIView!
    @IBOutlet weak var MapView: MKMapView!
    let backMapView:UIView = UIView.init()
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if currnetUser.uType == userGeneral.getNUStrFormat(){
            self.navigationItem.rightBarButtonItem = nil
            self.checkSubsribtion()
            self.checkVolunteering()
        } else {
            subscribeBtn.isHidden = true
            VolunteerBtn.isHidden = true
        }
        
        if (fromWhere == "Map") {
            viewOnMapBtn.isHidden = true
        }
        
        //to show Event details
        if let EventObj = EveHolder {
            self.loadData(EventObj: EventObj)
        }
        
        postionView()
        
        EventDescription.sizeToFit()
        
        imageScrollView.delegate = self
        imageScrollView.minimumZoomScale = 1.0
        imageScrollView.maximumZoomScale = 6.0
        
        backMapView.frame = view.frame
        backMapView.center = view.center
        backMapView.backgroundColor = UIColor.white
        backMapView.alpha = 0.8
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkSubsribtion() {
        FBDBHandler.FBDBHandlerObj.loadIdOfSubscribedEvents(UID: currnetUser.UID, completion: {
            if let user = currnetUser as? normalUser {
                if (user.didISubIn(EID: (self.EveHolder?.EID)!)) {
                    self.subscribeBtn.setTitle("Subscribed",for: .normal)
                    self.subscribeBtn.backgroundColor = UIColor(named: "orangRed2")
                    self.checkIfTheCurrentUserAfterHeOrSheOpenedThisEventAlreadySubscribedForThisEventOrNot = true
                } else {
                    self.checkIfTheCurrentUserAfterHeOrSheOpenedThisEventAlreadySubscribedForThisEventOrNot = false
                }
            }
        })
    }
    
    func checkVolunteering() {
        FBDBHandler.FBDBHandlerObj.loadEventsUserVoledIn(UID: currnetUser.UID, completion: {
            if let user = currnetUser as? normalUser {
                if (user.didIVolIn(EID: (self.EveHolder?.EID)!)) {
                    self.VolunteerBtn.setTitle("Requested",for: .normal)
                    self.VolunteerBtn.backgroundColor = UIColor(named: "orangRed2")
                    self.VolunteerBtn.isEnabled = false
                }
            }
        })
    }
    
    func postionView(){
        let superViewFrame = self.view.frame
        let superViewCenter = self.view.center
        BGPopupView.frame = superViewFrame
        BGPopupView.center = superViewCenter
        BGPopupView.backgroundColor = UIColor.white
        
        VIView.frame = superViewFrame
        VIView.center = superViewCenter
    }
    
    func loadData(EventObj: Event) {
       if  let EID = EventObj.EID,
            let EventimageURL = EventObj.EventImageURL,
            let Description = EventObj.EventDescription,
            let EMUID = EventObj.EventManagerID,
            let EMObbj:eventManager = userGeneral.getUserObjBy(UID: EMUID) as? eventManager,
            let EMProfileImgURL = EMObbj.picURL,
            let EMName = EMObbj.name,
            let EventNameString = EventObj.EventName,
            let EventattendenceType = EventObj.AttendenceType,
            let EventTime: String = EventObj.EventTime.getBothTimesInOneString(),
            let EventFromdate: String = EventObj.EventFDate.getDateFormatAsString() ,
            let EventEnddate: String = EventObj.EventEDate.getDateFormatAsString() {

            FBDBHandler.FBDBHandlerObj.getImageBy(URL: EventimageURL, imageViewToLoadOn: EventImage)
            FBDBHandler.FBDBHandlerObj.getImageBy(URL: EMProfileImgURL, imageViewToLoadOn:self.profileImage)
            self.EMName.text = EMName
            EventDescription.text = Description
            EventName.text = EventNameString
            attendenceType.text = EventattendenceType
            Time.text = EventTime
            Date.text = "\(EventFromdate) - \(EventEnddate)"
        }
    }
    
    @IBAction func viewImgBtnPessed(_ sender: Any) {
        VIImgView.image = EventImage.image
        addPopupView(pupupView: VIView)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return VIImgView
    }
    
    @IBAction func imageActionBtnPressed(_ sender: Any) {
        imageAction()
    }
    
    @objc func imageAction() {
        guard let image = VIImgView.image else {return}
        
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func shareBtnPressed(_ sender: Any) {
        let firstActivityItem = "Text you want"
        let secondActivityItem : NSURL = NSURL(string: "http//:urlyouwant")!
        
        // If you want to put an image
        //let image : UIImage = UIImage(named: "image.jpg")!
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, secondActivityItem], applicationActivities: nil)
        
        // This lines is for the popover you need to show in iPad
        activityViewController.popoverPresentationController?.sourceView = (sender as! UIButton)
        
        // This line remove the arrow of the popover to show in iPad
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        // Things to exclude
        activityViewController.excludedActivityTypes = [
            UIActivityType.postToWeibo
//            UIActivityType.print,
//            UIActivityType.assignToContact,
//            UIActivityType.saveToCameraRoll,
//            UIActivityType.addToReadingList,
//            UIActivityType.postToFlickr,
//            UIActivityType.postToVimeo,
//            UIActivityType.postToTencentWeibo
        ]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func subscribeBtnPressed(_ sender: Any) {
        if (checkIfTheCurrentUserAfterHeOrSheOpenedThisEventAlreadySubscribedForThisEventOrNot) {
            if let UserID =  currnetUser.UID,
                let EventID = EveHolder?.EID {
                self.subscribeBtn.setTitle("Subscribe",for: .normal)
                self.subscribeBtn.backgroundColor = UIColor.lightGray
                FBDBHandler.FBDBHandlerObj.unSubscripEve(EID: EventID, UID: UserID)
                checkIfTheCurrentUserAfterHeOrSheOpenedThisEventAlreadySubscribedForThisEventOrNot = false
            }
        } else {
            if let UserID =  currnetUser.UID,
                let EventID = EveHolder?.EID {
                self.subscribeBtn.setTitle("Subscribed",for: .normal)
                self.subscribeBtn.backgroundColor = UIColor(named: "orangRed2")
                FBDBHandler.FBDBHandlerObj.subscripEve(EID: EventID, UID: UserID)
                checkIfTheCurrentUserAfterHeOrSheOpenedThisEventAlreadySubscribedForThisEventOrNot = true
            }
        }
    }
    
    @IBAction func volunteerInBtnPressed(_ sender: Any) {
        if let UserID =  currnetUser.UID,
            let EventID = EveHolder?.EID,
            let EMID = EveHolder?.EventManagerID{
            self.VolunteerBtn.setTitle("Requested",for: .normal)
            self.VolunteerBtn.backgroundColor = UIColor(named: "orangRed2")
            self.VolunteerBtn.isEnabled = false
            FBDBHandler.FBDBHandlerObj.ReqVolInAnEve(EID: EventID, UID: UserID)
            
            //notifcation to event-Manager
            if EMID != ""{
                FBDBHandler.FBDBHandlerObj.addNtfVolReqInEveToEM(VolUID: UserID, EMUID: EMID)
            }
        }
    }
    
    @IBAction func editBtnPressed(_ sender: Any) {
        self.EditView.frame.size = self.view.frame.size
        self.view.addSubview(self.EditView)
        self.EditView.center = self.view.center
    }
    
    @IBAction func viewVolunteersBtnPressed(_ sender: Any) {
        loadVolunteers()
        self.VolunteerView.frame.size = self.view.frame.size
        self.view.addSubview(self.VolunteerView)
        self.VolunteerView.center = self.view.center
    }
    
    func loadVolunteers() {
        volunteers = []
        if (whichTableView == 0) {
            FBDBHandler.FBDBHandlerObj.loadVolunteersInEvent(EventObj: self.EveHolder!, completion: {
                self.volunteers = self.EveHolder!.getUnAcceptedVols()
                self.volunteersTableView.reloadData()
            })
        } else if (whichTableView == 1) {
            FBDBHandler.FBDBHandlerObj.loadVolunteersInEvent(EventObj: self.EveHolder!, completion: {
                self.volunteers = self.EveHolder!.getAcceptedVols()
                self.volunteersTableView.reloadData()
            })
        }
    }
    
    @IBAction func EditEventBtnPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "editEve", sender: EveHolder)
    }
    
    @IBAction func deleteBtnPressed(_ sender: Any) {
        deleteAlert(title: "Are you sure you want to delete this event?", message: "The event will be permanently deleted.")
    }
    
    func deleteAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.destructive, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            print ("No")
        }))
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            if let EventID = self.EveHolder?.EID {
                FBDBHandler.FBDBHandlerObj.deleteEve(EID: EventID, onSucces: {
                    ProgressHUD.showSuccess("Event Deleted")
                    self.dismiss(animated: true, completion: nil)
                    self.EditView.removeFromSuperview()
                    self.navigationController?.popViewController(animated: true)
                    self.dismiss(animated: true, completion: nil)
                }, onError: {})
            }
            print("Yes")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        self.EditView.removeFromSuperview()
    }
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        self.VolunteerView.removeFromSuperview()
    }
    
    //view Img View actions
    @IBAction func VICloseBtnPressed(_ sender: Any) {
        removePopupView(pupupView: VIView, Comp: {})
    }
    
    func addPopupView(pupupView:UIView){
        BGPopupView.alpha = 0
        pupupView.alpha = 0
        
        self.view.addSubview(BGPopupView)
        UIApplication.shared.keyWindow?.addSubview(pupupView)
        pupupView.transform = CGAffineTransform(translationX: 0, y: 30)
        
        UIView.animate(withDuration: 0.3 , animations: {
            pupupView.transform = .identity
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
    
    @IBAction func acceptBtnPressed(_ sender: Any) {
        print("accept Btn Pressed")
        acceptVolunteer(index: (index?.row)!)
    }
    
    @IBAction func rejectBtnPressed(_ sender: Any) {
        print("reject Btn Pressed")
        rejectVolunteer(index: (index?.row)!)
    }
    
    @IBAction func rateBtnPressed(_ sender: Any) {
        if let volObjTorate:normalUser = (volunteers[(index?.row)!]).volObj{
            performSegue(withIdentifier: "rateVolVC", sender: volObjTorate)
        }
    }
    
    // Start of map methods
    @IBAction func viewOnMap(_ sender: Any) {
        self.MapView.layer.cornerRadius = 15
        self.MapSubView.frame.size = self.view.frame.size
        self.MapSubView.frame.size = CGSize(width: self.view.frame.width - 60, height: 600)
        self.view.addSubview(self.backMapView)
        self.view.addSubview(self.MapSubView)
        self.MapSubView.center = self.view.center
        self.MapSubView.layer.cornerRadius = 15
        showEventOnMap()
    }
    
    @IBAction func closeMapViewBtnPressed(_ sender: Any) {
        self.MapSubView.removeFromSuperview()
        self.backMapView.removeFromSuperview()
    }
    
    func showEventOnMap () {
        let EventName = EveHolder?.EventName
        let EventAttendenceType = EveHolder?.AttendenceType
        
        let location = CLLocationCoordinate2D(latitude: CLLocationDegrees((EveHolder?.Eventlatitude)!),longitude: CLLocationDegrees((EveHolder?.Eventlongitude)!))
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: location, span: span)
        MapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = EventName
        annotation.subtitle = EventAttendenceType
        MapView.addAnnotation(annotation)
    }
    
    @IBAction func goButtonTapped(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Choose application", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Maps", style: .default, handler: self.mapsHandler))
        actionSheet.addAction(UIAlertAction(title: "Google Maps", style: .default, handler: self.googleMapsHandler))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func mapsHandler(action: UIAlertAction!) {
        print("you chose Maps!")
        
        let latitude: CLLocationDegrees = (EveHolder?.Eventlatitude)!
        let longitude: CLLocationDegrees = (EveHolder?.Eventlongitude)!
        let regionDistance: CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = EveHolder?.EventName
        mapItem.openInMaps(launchOptions: options)
    }
    
    func googleMapsHandler(action: UIAlertAction!) {
        print("you chose Google Maps!")
        
        UIApplication.shared.open(URL(string:"https://www.google.com/maps/search/?api=1&query=\((EveHolder?.Eventlatitude)!),\((EveHolder?.Eventlongitude)!)")!, options: [:], completionHandler: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destnation = segue.destination as? CreateEventVC {
            if let evesObj = sender as? Event{
                destnation.eventObjForUpdate = evesObj
            }
        }else if let destnation = segue.destination as? rateVolVC {
            if let volObj = sender as? normalUser,
                let EventObbj = self.EveHolder as? Event{
                destnation.VolObbj = volObj
                destnation.EveObbj = EventObbj
            }
        }else if let destnation = segue.destination as? AnyUserInfoVC{
            if let volObj = sender as? userGeneral{
                destnation.UserObj = volObj
            }
        }
    } // End prepare for segue
}

extension ViewEventVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return volunteers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        index = indexPath
        let cell = tableView.dequeueReusableCell(withIdentifier: "VolunteerCell", for: indexPath) as! VolunteerTableViewCell
        cell.selectionStyle = .none
        cell.whichTableView = self.whichTableView
        cell.cellDelegate = self
        cell.index = indexPath
        cell.awakeFromNib()
        
        if let vol = volunteers[indexPath.row].volObj {
            cell.volunteerName.text = vol.name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        if let vol = volunteers[indexPath.row].volObj {
            performSegue(withIdentifier: "showProfileInfo", sender: vol)
        }
        
    }
    
    @IBAction func switchTableViewSegment(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0) {
            whichTableView = 0
        } else if (sender.selectedSegmentIndex == 1) {
            whichTableView = 1
        }
        loadVolunteers()
    }
}

extension ViewEventVC: TableViewNew {
    func acceptVolunteer(index: Int) {
        if let EventID = self.EveHolder!.EID ,
            let vol = volunteers[index].volObj{
            FBDBHandler.FBDBHandlerObj.acceptVolReq(EID: EventID, UID: vol.UID)
            loadVolunteers()
            volunteersTableView.reloadData()
        }
    }
    
    func rejectVolunteer(index: Int) {
        if let EventID = self.EveHolder!.EID ,
            let vol = volunteers[index].volObj{
            FBDBHandler.FBDBHandlerObj.rejectVolReq(EID: EventID, UID: vol.UID)
            loadVolunteers()
            volunteersTableView.reloadData()
        }
    }
    
    // Not ready yet!!!
    func rateVolunteer(index: Int) {
        if let EventID = self.EveHolder!.EID {
            //FBDBHandler.FBDBHandlerObj.rateAcceptedVol(UID: EventID, Rate: <#T##Double#>)
            volunteersTableView.reloadData()
        }
    }
}
