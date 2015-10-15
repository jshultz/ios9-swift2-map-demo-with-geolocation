//
//  ViewController.swift
//  map-user-location
//
//  Created by Jason Shultz on 10/14/15.
//  Copyright © 2015 HashRocket. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate  {
    
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var courseLabel: UILabel!
    
    @IBOutlet weak var speedLabel: UILabel!
    
    @IBOutlet weak var altitudeLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    
    
    var locationManager = CLLocationManager()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Get Location
        
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
        
        // Ending

    }
    
    func addMarker(location:CLLocationCoordinate2D){
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = location
        
        annotation.title = "This awesome place"
        
        annotation.subtitle = "If you were here you would know it."
        
        map.addAnnotation(annotation)
        
    }
    
    func updateLabels(course:String, speed:String, altitude:String){
        courseLabel.text = "Course: \(course)"
        speedLabel.text = "Speed: \(speed)"
        altitudeLabel.text = "Altitude: \(altitude)"
        
    }
    
    func displayAddress(userLocation:CLLocation){
        CLGeocoder().reverseGeocodeLocation(userLocation, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if let pm = placemarks?.first {
                
                var subThoroughfare:String = ""
                var thoroughfare:String = ""
                
                if (pm.subThoroughfare != nil) {
                    subThoroughfare = String(pm.subThoroughfare!)
                }
                
                if (pm.thoroughfare != nil) {
                    thoroughfare = String(pm.thoroughfare!)
                }
                
                let locality:String! = String(pm.locality!)
                let subAdministrativeArea:String! = String(pm.subAdministrativeArea!)
                
                
                self.addressLabel.text = "Address: \(subThoroughfare) \(thoroughfare) \n \(locality), \(subAdministrativeArea)"
                
            }
            else {
                print("Problem with the data received from geocoder")
            }
        })
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        
        let latitude:CLLocationDegrees = userLocation.coordinate.latitude
        
        let longitude:CLLocationDegrees = userLocation.coordinate.longitude
        
        let latDelta:CLLocationDegrees = 0.05 // must use type CLLocationDegrees
        
        let lonDelta:CLLocationDegrees = 0.05 // must use type CLLocationDegrees
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta) // Combination of two Delta Degrees
        
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude) // Combination of the latitude and longitude variables
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span) // takes span and location and uses those to set the region.
        
        addMarker(location)
        displayAddress(userLocation)
        
        let course:String = String(userLocation.course)
        let speed:String = String(userLocation.speed)
        let altitude:String = String(userLocation.altitude)
        
        updateLabels(course, speed: speed, altitude: altitude)
        
        map.setRegion(region, animated: false) // Take all that stuff and make a map!
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

