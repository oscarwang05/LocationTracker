//
//  Location.swift
//  LocationTracker
//
//  Created by Milo on 28/06/2022.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    
    static let shared = LocationManager()
    let manager = CLLocationManager()
    
    var completion : ((CLLocation) -> Void)?
    
    func getCurrentLocation(completion: @escaping((_ locations : CLLocation) -> Void)) {
        self.completion = completion
        manager.delegate = self
        manager.distanceFilter = kCLDistanceFilterNone
        manager.requestWhenInUseAuthorization()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else {
            return
        }
        completion?(currentLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            
        case .authorizedWhenInUse, .authorizedAlways:
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.startUpdatingLocation()
            
        case .denied, .restricted:
            print("Oops, I am not allowed to update the location")
            
        default:
            break
        }
    }
}
