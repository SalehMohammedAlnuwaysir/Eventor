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
    @IBOutlet weak var goButton: UIButton!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    var previousLocation: CLLocation?
    
    let geoCoder = CLGeocoder()
    var directionsArray: [MKDirections] = []
    

    @IBOutlet weak var mapSearchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goButton.layer.cornerRadius = goButton.frame.size.height/2
        mapSearchBar.delegate = self
        checkLocationServices()
        loadEvents()
    }
    
    func loadEvents() {
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
                self.showEventOnMap(eventToLoad: event)
                self.events.append(event)
            }
        }
    }
    
    func showEventOnMap (eventToLoad: Event) {
        print(eventToLoad.Eventlatitude)
        print(eventToLoad.Eventlongitude)
        let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(eventToLoad.Eventlatitude),longitude: CLLocationDegrees(eventToLoad.Eventlongitude))
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        //mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = eventToLoad.EventName
        annotation.subtitle = eventToLoad.AttendenceType
        mapView.addAnnotation(annotation)
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
        previousLocation = getCenterLocation(for: mapView)
    }
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    

    func getDirections() {
        guard let location = locationManager.location?.coordinate else {
            //TODO: Inform user we don't have their current location
            return
        }
        
        let request = createDirectionsRequest(from: location)
        let directions = MKDirections(request: request)
        resetMapView(withNew: directions)
        
        directions.calculate { [unowned self] (response, error) in
            //TODO: Handle error if needed
            guard let response = response else { return } //TODO: Show response not available in an alert
            
            for route in response.routes {
                self.mapView.add(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }

    func createDirectionsRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request {
        let destinationCoordinate       = getCenterLocation(for: mapView).coordinate
        let startingLocation            = MKPlacemark(coordinate: coordinate)
        let destination                 = MKPlacemark(coordinate: destinationCoordinate)
        
        let request                     = MKDirections.Request()
        request.source                  = MKMapItem(placemark: startingLocation)
        request.destination             = MKMapItem(placemark: destination)
        request.transportType           = .automobile
        request.requestsAlternateRoutes = true
        
        return request
    }
    

    func resetMapView(withNew directions: MKDirections) {
        mapView.removeOverlays(mapView.overlays)
        directionsArray.append(directions)
        let _ = directionsArray.map { $0.cancel() }
    }
    

    @IBAction func goButtonTapped(_ sender: UIButton) {
        getDirections()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        mapSearchBar.resignFirstResponder()
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(mapSearchBar.text!) { (placemarks:[CLPlacemark]?, error:Error?) in
            if error == nil {
                let placemark = placemarks?.first
                let anno = MKPointAnnotation()
                anno.coordinate = (placemark?.location?.coordinate)!
                anno.title = self.mapSearchBar.text!
                
                let span = MKCoordinateSpanMake(0.075, 0.075)
                let region = MKCoordinateRegion(center: anno.coordinate, span: span)
                self.mapView.setRegion(region, animated: true)
                self.mapView.addAnnotation(anno)
                self.mapView.selectAnnotation(anno, animated: true)
            } else {
                print(error?.localizedDescription ?? "error")
            }
        }
    }
}


extension MapVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

extension MapVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        
        guard let previousLocation = self.previousLocation else { return }
        
        guard center.distance(from: previousLocation) > 50 else { return }
        self.previousLocation = center
        
        geoCoder.cancelGeocode()
        
        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            if let _ = error {
                //TODO: Show alert informing the user
                return
            }
            
            guard let placemark = placemarks?.first else {
                //TODO: Show alert informing the user
                return
            }
            
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""

        }
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .blue
        
        return renderer
    }
}
