//
//  CreateEventVC.swift
//  Eventor
//
//  Created by Saleh on 02/06/1440 AH.
//  Copyright © 1440 Eventor. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import MapKit
import CoreLocation

class CreateEventVC: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var EventPhoto: UIImageView!
    @IBOutlet weak var EventNameTxt: UITextField!
    @IBOutlet weak var AttendenceTypeSgt: UISegmentedControl!
    @IBOutlet weak var AddLocationBtn: RoundedBtn!
    @IBOutlet weak var EventDescription: UITextView!
    @IBOutlet weak var CreatBtn:RoundedBtn!
    var intrestsArr:[String] = []
    
    //MARK: - addNewEve
    var tileCheck:Bool! = false
    var LocationCheck:Bool! = false
    
    @IBOutlet weak var newEveFromTimeBtn: UIButton!
    @IBOutlet weak var newEveToTimeBtn: UIButton!
    @IBOutlet weak var newEveFromDateBtn: UIButton!
    @IBOutlet weak var newEveToDateBtn: UIButton!
    
    var whatBtnPressedForDateTime:String = ""
    var newEveFDate:date = date.init()
    var newEveTDate:date = date.init()

    var newEveTime:time =  time.init()
    var newEveFromTime:Bool! = false
    var newEveToTime:Bool! = false
    var newEveFromDate:Bool! = false
    var newEveToDate:Bool! = false
    
    //MARK:- Date&Time (newEve)
    @IBOutlet var newEveDateTimeView: UIView!
    @IBOutlet weak var newEveDateTimeBGView: UIView!
    @IBOutlet weak var newEveDateTimeHeaderLbl: UILabel!
    @IBOutlet weak var newEveDateTimePicker: UIDatePicker!
    @IBOutlet weak var newEveDateTimeDoneBtn: UIButton!
    
    var eventFromTime: String!
    var eventToTime: String!
    var eventFromDate: String!
    var eventToDate: String!
    
    var attendenceType: String!
    
    var selectedImage: UIImage?
    
    @IBOutlet var locationView: UIView!
    @IBOutlet weak var MapView: MKMapView!
    let locationManager = CLLocationManager()
    @IBOutlet weak var hasLocation: UIImageView!
    
    let geoCoder = CLGeocoder()
    var latitude: Double!
    var longitued: Double!
    
    
    //for edit event
    var eventObjForUpdate:Event!
    
    //Sponsor Event
    var isItForSponsore = false
    
    //
    var dateLimit = Calendar.current.date(byAdding: .day, value: -1, to: Date())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HindeKeyboardViewTouched()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectEventPhoto))
        EventPhoto.addGestureRecognizer(tapGesture)
        EventPhoto.isUserInteractionEnabled = true
        checkLocationServices()
        hasLocation.isHidden = true

        if eventObjForUpdate != nil {
            updateViewForEditEve()
        }
        
        textFieldsMaxLength()
    }
    
    func textFieldsMaxLength() {
        EventNameTxt.delegate = self
        EventDescription.delegate = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case EventNameTxt:
            let maxLength = 40
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        default:
            return false
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        switch textView {
        case EventDescription:
            let maxLength = 500
            let currentString: NSString = textView.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: text) as NSString
            return newString.length <= maxLength
        default:
            return false
        }
    }
    
    func updateViewForEditEve(){
        if  let EID:String = eventObjForUpdate.EID,
            let eventPicURL:String = eventObjForUpdate?.EventImageURL,
            let eveName:String = eventObjForUpdate?.EventName,
            let eveFromTime:String = eventObjForUpdate?.EventTime.getFromTimeFormatAsString(),
            let eveToTime:String = eventObjForUpdate?.EventTime.getToTimeFormatAsString(),
            let eveFDate:String = eventObjForUpdate?.EventFDate.getDateFormatAsString(),
            let eveEDate:String = eventObjForUpdate?.EventEDate.getDateFormatAsString(),
            let attType:String = eventObjForUpdate?.AttendenceType,
            let desc:String = eventObjForUpdate?.EventDescription ,
            let Latitude = eventObjForUpdate?.Eventlatitude,
            let Longitued = eventObjForUpdate?.Eventlongitude
        {
            
            //intrest
            if  let intrests = eventObjForUpdate?.EventIntrests {
                intrestsArr = intrests

            }

            //setInfo
            newEveTime = eventObjForUpdate!.EventTime
            
            newEveFDate = (eventObjForUpdate?.EventFDate)!
            newEveTDate = (eventObjForUpdate?.EventEDate)!
            
            newEveFromTime = true
            newEveToTime = true
            newEveFromDate = true
            newEveToDate = true
            
            
            eventFromTime = eveFromTime
            eventToTime = eveToTime
            eventFromDate = eveFDate
            eventToDate = eveEDate
            
            
            //textFeilds
            FBDBHandler.FBDBHandlerObj.getImageBy(URL: eventPicURL, imageViewToLoadOn: EventPhoto)
            EventNameTxt.text = eveName
            newEveFromTimeBtn.setTitle("\(eveFromTime)", for: .normal)
            newEveToTimeBtn.setTitle("\(eveToTime)", for: .normal)
            newEveFromDateBtn.setTitle("\(eveFDate)", for: .normal)
            newEveToDateBtn.setTitle("\(eveEDate)", for: .normal)
            
            EventDescription.text = desc
            CreatBtn.setTitle("update event", for: .normal)
            
            //segments
            self.attendenceType = attType
            switch attendenceType{
            case "Male" : AttendenceTypeSgt.selectedSegmentIndex = 0
            
                break;
            case "Female" : AttendenceTypeSgt.selectedSegmentIndex = 1
                break;
            case "Families" : AttendenceTypeSgt.selectedSegmentIndex = 2
                break;

            default:
                break;

            }
            

            //map
            latitude = Latitude
            longitued = Longitued
            self.hasLocation.isHidden = false
            self.AddLocationBtn.setTitle("Edit",for: .normal)
            
           
            
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func handleSelectEventPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    //MARK: - newEve View Actions
    @IBAction func newEveChoosFromTimeBtnPressed(_ sender: Any) {
        newEveDateTimeView.center = view.center
        
        //prepar
        whatBtnPressedForDateTime = "FromTime"
        newEveDateTimeHeaderLbl.text = "Start time"
        newEveDateTimePicker.datePickerMode = .time
        
        self.view.addSubview(newEveDateTimeView)
    }
    
    @IBAction func newVenChoosToTimeBtnPressed(_ sender: Any) {
        newEveDateTimeView.center = view.center
        
        //prepar
        whatBtnPressedForDateTime = "ToTime"
        newEveDateTimeHeaderLbl.text = "End time"
        newEveDateTimePicker.datePickerMode = .time
        
        self.view.addSubview(newEveDateTimeView)
    }
    
    @IBAction func newEveChoosFromDateBtnPressed(_ sender: Any) {
        newEveDateTimeView.center = view.center
        //prepar
        whatBtnPressedForDateTime = "FromDate"
        newEveDateTimeHeaderLbl.text = "Start Event date"
        newEveDateTimePicker.datePickerMode = .date

        newEveDateTimePicker.minimumDate = nil
        
        self.view.addSubview(newEveDateTimeView)
        
    }
    
    @IBAction func newEveChoosToDateBtnPressed(_ sender: Any) {
        newEveDateTimeView.center = view.center
        //prepar
        whatBtnPressedForDateTime = "ToDate"
        newEveDateTimeHeaderLbl.text = "End Event date"
        newEveDateTimePicker.datePickerMode = .date
        
        newEveDateTimePicker.minimumDate = dateLimit
        
        self.view.addSubview(newEveDateTimeView)
    }
    
    @IBAction func dateTimeViewDoneBtnPressed(_ sender: Any) {
        //for sure will be choosen so lets close it first and do the others in the BG
        newEveDateTimeView.removeFromSuperview()
        //proccess
        if  whatBtnPressedForDateTime == "FromTime" {
            let Fhh = String(newEveDateTimePicker.date.getHourMinute().hour)
            let Fmm = String(newEveDateTimePicker.date.getHourMinute().minute)
            
            newEveFromTime = true
           
            newEveTime._fromTimeHH = Fhh
            newEveTime._fromTimeMM = Fmm
        
            newEveFromTimeBtn.titleLabel?.text = " \(Fhh):\(Fmm)"
            eventFromTime = " \(Fhh):\(Fmm)"
        } else if whatBtnPressedForDateTime == "ToTime"{
            let Thh = String(newEveDateTimePicker.date.getHourMinute().hour)
            let Tmm = String(newEveDateTimePicker.date.getHourMinute().minute)
            
            newEveToTime = true
            newEveTime._toTimeHH = Thh
            newEveTime._toTimeMM = Tmm
            
            newEveToTimeBtn.titleLabel?.text = " \(Thh):\(Tmm)"
            eventToTime = " \(Thh):\(Tmm)"
        } else if whatBtnPressedForDateTime == "FromDate"{
            let d = newEveDateTimePicker.date.getDMY().D
            let m = newEveDateTimePicker.date.getDMY().M
            let y = newEveDateTimePicker.date.getDMY().Y
            
            newEveFromDate = true
            
            dateLimit = newEveDateTimePicker.date
            
            newEveFDate = date.init(D: d, M: m, Y: y)
            newEveFromDateBtn.titleLabel?.text = "\(d)/\(m)/\(y)"
            eventFromDate = "\(d)/\(m)/\(y)"
        } else if whatBtnPressedForDateTime == "ToDate"{
            let d = newEveDateTimePicker.date.getDMY().D
            let m = newEveDateTimePicker.date.getDMY().M
            let y = newEveDateTimePicker.date.getDMY().Y
            
            newEveToDate = true
            
            newEveTDate = date.init(D: d, M: m, Y: y)
            newEveToDateBtn.titleLabel?.text = "\(d)/\(m)/\(y)"
            eventToDate = "\(d)/\(m)/\(y)"
        }
    }
    
    @IBAction func attendenceTypeSelected(_ sender: UISegmentedControl) {
        attendenceType = sender.titleForSegment(at: sender.selectedSegmentIndex)
    }
    
    @IBAction func addIntestsBBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "intrestsVC", sender: intrestsArr)
    }
    
    @IBAction func locationBtnPressed(_ sender: Any) {
        self.locationView.frame.size = self.view.frame.size
        self.view.addSubview(self.locationView)
        self.locationView.center = self.view.center
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func startTackingUserLocation() {
        MapView.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(location, 200, 200)
            MapView.setRegion(region, animated: true)
        }
    }
   
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = MapView.centerCoordinate.latitude
        let longitude = MapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            startTackingUserLocation()
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        }
    }
    
    @IBAction func chooseLocationBtnPressed(_ sender: Any) {
        latitude = (MapView.centerCoordinate.latitude)
        longitued = (MapView.centerCoordinate.longitude)

        self.AddLocationBtn.setTitle("Edit",for: .normal)

        if let LT = latitude,
            let LG = longitued{
            print(LT)
            print(LG)
            self.locationView.removeFromSuperview()
            self.hasLocation.isHidden = false
        }
    }
    
    @IBAction func createBtnPressed(_ sender: Any) {
        //for edit event
        selectedImage = EventPhoto.image
        
        ProgressHUD.show("", interaction: false)
        if (EventDescription.text == "") {
            ProgressHUD.showError("Please fill in all information")
        } else {
            if let profileImageStorage = self.selectedImage,
                let imageData = UIImageJPEGRepresentation(profileImageStorage, 0.8),
                let EMID = Auth.auth().currentUser?.uid,
                let eventName = EventNameTxt.text,
                let attendenceType = attendenceType,
                let eventDescription = EventDescription.text,
                let Etime:time = newEveTime,
                
                let EFdate:date = newEveFDate,
                let EEdate:date = newEveTDate,

                
                let EFT = eventFromTime,
                let ETT = eventToTime,
                let EFD = eventFromDate,
                let ETD = eventToDate,
                
                let Elatitude = latitude,
                let Elongitude = longitued,
                let needVol:Bool = false,
                let needSponsor:Bool = false
            {
                let photoString  = NSUUID().uuidString
                let StorageRef = Storage.storage().reference(forURL: "gs://eventor-f52a8.appspot.com")
                let EventImageRef = StorageRef.child("EventImage").child(photoString)
                EventImageRef.putData(imageData, metadata: nil) { (metadata, error) in
                    if error != nil {
                        return
                    }
                    EventImageRef.downloadURL { (url, error) in
                        guard let downloadURL = url else {
                            // Uh-oh, an error occurred!
                            return
                        }
                        let EventImageURL = downloadURL
                        let EventImageURLString = EventImageURL.absoluteString

                        print(Elatitude)
                        print(Elongitude)

                        let newEveObj:Event = Event.init(EID: "", EventNameTxt: eventName, AttendenceTypeTxt: attendenceType, EventDescriptionTxt: eventDescription, EventImageURLString: EventImageURLString,EveIntrests:self.intrestsArr, EMID: EMID, ET: Etime, FD: EFdate,ED: EEdate, Elatitude: Elatitude, Elongitude: Elongitude, needVol:true)
                        
                        
                        if self.eventObjForUpdate == nil { //creat event
                            
                            
                            if !self.isItForSponsore{ // the event is not for sponsor
                                
                                FBDBHandler.FBDBHandlerObj.addEve(newEveObj: newEveObj, onSucces: {
                                    ProgressHUD.showSuccess("New Event Created")
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    self.navigationController?.popViewController(animated: true)
                                    }
                                    self.navigationController?.popViewController(animated: true)
                                    
                                    //addNotifcationToUsers
                                    
                                }, onError: {
                                    notificationHelper.notificationHelperObj.showError(callerVC: self, Err: "somethin wnet wrong! With DB", color: .red)
                                })
                                
                            }else{// the event is for sponsor
                                newEveObj.EventManagerID = ""
                                //start adding event as Requsted Eevent
                                FBDBHandler.FBDBHandlerObj.addEveReqToSponsor(newEveObj: newEveObj, onSucces: {
                                    ProgressHUD.showSuccess("New Event Request added")
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.navigationController?.popViewController(animated: true)
                                    }
                                self.navigationController?.popViewController(animated: true)
                                }, onError: {
                                    notificationHelper.notificationHelperObj.showError(callerVC: self, Err: "somethin wnet wrong! With DB", color: .red)
                                })
                            }
                            
                        }else{ //update event
                            newEveObj.EID = self.eventObjForUpdate.EID
                            FBDBHandler.FBDBHandlerObj.updateEve(newEveObj: newEveObj, onSucces: {
                                
                                ProgressHUD.showSuccess("New Event updated")
                                self.navigationController?.popViewController(animated: true)
                            }, onError: {
                                notificationHelper.notificationHelperObj.showError(callerVC: self, Err: "somethin wnet wrong! With DB", color: .red)
                            })
                        }
                        
                        
                    }
                }
            } else {
            ProgressHUD.showError("Please fill in all information")
            }
        }
    }

    @IBAction func cancelBtnPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destnation = segue.destination as? intrestsVC {
            if let intrestsArrObj = sender as? [String]{
                destnation.ArrayOfIntrests = intrestsArrObj
                destnation.callerVC = self
            }
        }
    }
}

extension CreateEventVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

extension CreateEventVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate, MKMapViewDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("Picked a photo")
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = image
            EventPhoto.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .blue
        return renderer
    }
}

