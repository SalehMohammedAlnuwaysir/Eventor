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

class CreateEventVC: UIViewController {
    @IBOutlet weak var EventPhoto: UIImageView!
    @IBOutlet weak var EventNameTxt: UITextField!
    @IBOutlet weak var AttendenceTypeSgt: UISegmentedControl!
    @IBOutlet weak var AddLocationBtn: RoundedBtn!
    @IBOutlet weak var EventDescription: UITextView!
    
    //MARK: - addNewEve
    var tileCheck:Bool! = false
    var LocationCheck:Bool! = false
    
    @IBOutlet weak var newEveFromTimeBtn: UIButton!
    @IBOutlet weak var newEveToTimeBtn: UIButton!
    @IBOutlet weak var newEveDateBtn: UIButton!
    var whatBtnPressedForDateTime:String = ""
    var newEveDate:date! = nil
    var newEveTime:time =  time.init()
    var newEveFromTime:Bool! = false
    var newEveToTime:Bool! = false
    //MARK:- Date&Time (newEve)
    @IBOutlet var newEveDateTimeView: UIView!
    @IBOutlet weak var newEveDateTimeBGView: UIView!
    @IBOutlet weak var newEveDateTimeHeaderLbl: UILabel!
    @IBOutlet weak var newEveDateTimePicker: UIDatePicker!
    @IBOutlet weak var newEveDateTimeDoneBtn: UIButton!
    
    var eventFromTime: String!
    var eventToTime: String!
    var eventDate: String!
    
    var attendenceType: String!
    
    var selectedImage: UIImage?
    
    @IBOutlet var locationView: UIView!
    @IBOutlet weak var MapView: MKMapView!
    let locationManager = CLLocationManager()
    @IBOutlet weak var hasLocation: UIImageView!
    
    let geoCoder = CLGeocoder()
    var latitude: Double!
    var longitued: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectEventPhoto))
        EventPhoto.addGestureRecognizer(tapGesture)
        EventPhoto.isUserInteractionEnabled = true
        checkLocationServices()
        hasLocation.isHidden = true
        // Do any additional setup after loading the view.
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
    
    @IBAction func newEveChoosDateBtnPressed(_ sender: Any) {
        newEveDateTimeView.center = view.center
        //prepar
        whatBtnPressedForDateTime = "Date"
        newEveDateTimeHeaderLbl.text = "Event date"
        newEveDateTimePicker.datePickerMode = .date
        
        
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
        } else if whatBtnPressedForDateTime == "Date"{
            let d = newEveDateTimePicker.date.getDMY().D
            let m = newEveDateTimePicker.date.getDMY().M
            let y = newEveDateTimePicker.date.getDMY().Y
            
            newEveDate = date.init(D: d, M: m, Y: y)
            newEveDateBtn.titleLabel?.text = "\(d)/\(m)/\(y)"
            eventDate = "\(d)/\(m)/\(y)"
        }
    }
    
    @IBAction func attendenceTypeSelected(_ sender: UISegmentedControl) {
        attendenceType = sender.titleForSegment(at: sender.selectedSegmentIndex)
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
        self.AddLocationBtn.titleLabel!.text = "Edit"
        
        if let LT = latitude,
            let LG = longitued{
            print(LT)
            print(LG)
            self.locationView.removeFromSuperview()
            self.hasLocation.isHidden = false
        }
        
    }
    
    
    @IBAction func createBtnPressed(_ sender: Any) {
        ProgressHUD.show("", interaction: false)
        if (EventDescription.text == "") {
            ProgressHUD.showError("Please fill in all information")
        } else {
            if let profileImageStorage = self.selectedImage,
                let imageData = UIImageJPEGRepresentation(profileImageStorage, 0.8),
                let eventName = EventNameTxt.text,
                let attendenceType = attendenceType,
                let eventDescription = EventDescription.text,
                let EFT = eventFromTime,
                let ETT = eventToTime,

                let ED = eventDate,
                let Elatitude = latitude,
                let Elongitude = longitued
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
                        self.sendDataToDatabase(EventName: eventName, AttendenceType: attendenceType, EventDescription: eventDescription, EventImageURLString: EventImageURLString, EFT: EFT, ETT: ETT, ED: ED, EventLatitude: Elatitude, EventLongitude: Elongitude)
                    }
                }
            } else {
            ProgressHUD.showError("Please fill in all information")
            }
        }
    }
    
    func sendDataToDatabase(EventName: String, AttendenceType: String, EventDescription: String, EventImageURLString: String, EFT: String, ETT: String, ED: String, EventLatitude: Double, EventLongitude: Double) {
        let ref = Database.database().reference()
        let EventsRef = ref.child("Events")
        let newEventId = EventsRef.childByAutoId().key!
        let NewEventRef = EventsRef.child(newEventId)
        let EventManagerID = Auth.auth().currentUser?.uid
        let postedDate = ServerValue.timestamp()

        NewEventRef.setValue(["EventName": EventName, "AttendenceType": attendenceType, "EventDescription": EventDescription, "EventImage": EventImageURLString, "EventManagerID": EventManagerID!, "EventFromTime": EFT, "EventToTime": ETT, "EventDate": ED, "PostedDate": postedDate, "Elatitude": EventLatitude, "Elongitude": EventLongitude], withCompletionBlock: { (error, ref) in
            if (error != nil) {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            ProgressHUD.showSuccess("New Event Created")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil) 
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
