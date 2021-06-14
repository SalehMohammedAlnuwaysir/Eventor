//
//  MapScreen.swift
//  MapKit-Directions
//
//  Created by Sean Allen on 9/1/18.
//  Copyright © 2018 Sean Allen. All rights reserved.
//

import UIKit

import Firebase
import FirebaseStorage
import FirebaseDatabase
import MapKit
import CoreLocation

class MapVC: UIViewController, UISearchBarDelegate {
    var events = [Event]()
    
    @IBOutlet weak var mapView: MKMapView!

    @IBOutlet weak var goButton: RoundedBtn!
    @IBOutlet weak var viewEventBtn: RoundedBtn!
    
    var tempAnnotaionID: String!
    var tempLatitude: Double!
    var tempLongtitude: Double!
    var tempLocationName: String!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 1000
    
    let geoCoder = CLGeocoder()
    var directionsArray: [MKDirections] = []

    //@IBOutlet weak var mapSearchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        HindeKeyboardViewTouched()

        hideButtons()

        checkLocationServices()
        newLoadEves()
    }
    

    
    
    @IBAction func reloadBtnPressed(_ sender:Any){
        newLoadEves()
    }
    func newLoadEves(){
        refrishingHanler.refrishingHanlerObj.startRefrising(view: self.view)

        FBDBHandler.FBDBHandlerObj.loadEves(onSucces: {
            if currnetUser.uType != userGeneral.getEMStrFormat(){
                refrishingHanler.refrishingHanlerObj.endRefrising(view: self.view)

                self.events = allEventsGlobalArry
                for eve in self.events{
                    self.showEventOnMap(eventToLoad: eve)
                }
            }else{
                print("\nYYYYYYYYYYYYYYYYYY\n")
                FBDBHandler.FBDBHandlerObj.loadMyEventsID(UID: currnetUser.UID, completion: {
                    if let MyEventIds:[String] =  (currnetUser as! eventManager).MyEvents {
                        print("\n==================\n")
                        
                        let  MyEvents:[Event] = Event.getEveListByIDsFromGolbEveArry(EIDs: MyEventIds)
                        print(MyEvents)
                        refrishingHanler.refrishingHanlerObj.endRefrising(view: self.view)
                        self.events = MyEvents
                        for eve in self.events{
                            self.showEventOnMap(eventToLoad: eve)
                        }                    }
                })
            }
            
        }, onError: {_ in })
    }
    
    func showEventOnMap (eventToLoad: Event) {
        let EventID = eventToLoad.EID
        let EventName = eventToLoad.EventName
        let EventAttendenceType = eventToLoad.AttendenceType
        
        let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(eventToLoad.Eventlatitude),longitude: CLLocationDegrees(eventToLoad.Eventlongitude))
        //let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        //let region = MKCoordinateRegion(center: location, span: span)
        //mapView.setRegion(region, animated: true)

        let annotation:MyAnnotation = MyAnnotation()
        annotation.coordinate = location
        annotation.title = EventName
        annotation.subtitle = EventAttendenceType
        annotation.ID = EventID
        mapView.addAnnotation(annotation)
    }
    
    func hideButtons() {
        goButton.isHidden = true
        viewEventBtn.isHidden = true
    }
    
    func showButtons() {
        goButton.isHidden = false
        viewEventBtn.isHidden = false
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(location, 8000, 8000)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
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
    
    func startTackingUserLocation() {
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
    }
    
//    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
//        let latitude = mapView.centerCoordinate.latitude
//        let longitude = mapView.centerCoordinate.longitude
//
//        return CLLocation(latitude: latitude, longitude: longitude)
//    }
    

//    func getDirections() {
//        guard let location = locationManager.location?.coordinate else {
//            //TODO: Inform user we don't have their current location
//            return
//        }
//
//        let request = createDirectionsRequest(from: location)
//        let directions = MKDirections(request: request)
//        resetMapView(withNew: directions)
//
//        directions.calculate { [unowned self] (response, error) in
//            //TODO: Handle error if needed
//            guard let response = response else { return } //TODO: Show response not available in an alert
//
//            for route in response.routes {
//                self.mapView.add(route.polyline)
//                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
//            }
//        }
//    }

//    func createDirectionsRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request {
//        let destinationCoordinate = getCenterLocation(for: mapView).coordinate
//        let startingLocation = MKPlacemark(coordinate: coordinate)
//        let destination = MKPlacemark(coordinate: destinationCoordinate)
//
//        let request = MKDirections.Request()
//        request.source = MKMapItem(placemark: startingLocation)
//        request.destination = MKMapItem(placemark: destination)
//        request.transportType = .automobile
//        request.requestsAlternateRoutes = true
//        return request
//    }
    

    func resetMapView(withNew directions: MKDirections) {
        
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
        
        let latitude: CLLocationDegrees = tempLatitude
        let longitude: CLLocationDegrees = tempLongtitude
        let regionDistance: CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = tempLocationName
        mapItem.openInMaps(launchOptions: options)
    }
    
    func googleMapsHandler(action: UIAlertAction!) {
        print("you chose Google Maps!")
        
        UIApplication.shared.open(URL(string:"https://www.google.com/maps/search/?api=1&query=\(tempLatitude!),\(tempLongtitude!)")!, options: [:], completionHandler: nil)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if (view.annotation is MKUserLocation) {
            return
        } else {
            tempLatitude = CLLocationDegrees((view.annotation?.coordinate.latitude)!)
            tempLongtitude = CLLocationDegrees((view.annotation?.coordinate.longitude)!)
            
            let location = CLLocationCoordinate2D(latitude: tempLatitude,longitude: tempLongtitude)
            let region = MKCoordinateRegionMakeWithDistance(location, 4000, 4000)
            mapView.setRegion(region, animated: true)
            var annotation:MyAnnotation = MyAnnotation()
            annotation = view.annotation as! MapVC.MyAnnotation
            tempAnnotaionID = annotation.ID
            tempLocationName = annotation.title
            
            showButtons()
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        hideButtons()
    }
    
    @IBAction func viewEventBtnPressed(_ sender: Any) {
        let VC = storyboard?.instantiateViewController(withIdentifier: "ViewEventVC") as? ViewEventVC
        let eveObj:Event  = Event.getEveByIDFromGolbEveArry(EID: tempAnnotaionID)

        VC?.fromWhere = "Map"
        VC?.EveHolder = eveObj
        FBDBHandler.FBDBHandlerObj.loadIdOfSubscribers(EventObj: eveObj, completion: {
            VC?.SubscribersLbl.text = "\(eveObj.getNumOfSubscribers())"
        })
        //VC?.EventTime = String(eveObj.EventTime!.getBothTimesInOneString())
        self.navigationController?.pushViewController(VC!, animated: true)
    }
    
    // Search method in case we need it
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        mapSearchBar.resignFirstResponder()
//        let geocoder = CLGeocoder()
//        geocoder.geocodeAddressString(mapSearchBar.text!) { (placemarks:[CLPlacemark]?, error:Error?) in
//            if error == nil {
//                let placemark = placemarks?.first
//                let anno = MKPointAnnotation()
//                anno.coordinate = (placemark?.location?.coordinate)!
//                anno.title = self.mapSearchBar.text!
//
//                let span = MKCoordinateSpanMake(0.075, 0.075)
//                let region = MKCoordinateRegion(center: anno.coordinate, span: span)
//                self.mapView.setRegion(region, animated: true)
//                self.mapView.addAnnotation(anno)
//                self.mapView.selectAnnotation(anno, animated: true)
//            } else {
//                print(error?.localizedDescription ?? "error")
//            }
//        }
//    }
}


extension MapVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

extension MapVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .blue
        
        return renderer
    }
    
    class MyAnnotation : MKPointAnnotation {
        var ID : String?
    }

}
