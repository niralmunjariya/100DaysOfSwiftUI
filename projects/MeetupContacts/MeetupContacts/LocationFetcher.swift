//
//  LocationFetcher.swift
//  MeetupContacts
//
//  Created by Niral Munjariya on 13/01/22.
//

import Foundation
import CoreLocation

class LocationFetcher: NSObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    var lastKnownLocation: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func start() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func stop(){
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first?.coordinate
    }
    
}
