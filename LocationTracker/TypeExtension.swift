//
//  TypeExtension.swift
//  LocationTracker
//
//  Created by Milo on 29/06/2022.
//

import Foundation
import MapKit

extension MKMapView {
    
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
        let coordinateRegion = MKCoordinateRegion(
                            center: location.coordinate,
                            latitudinalMeters: regionRadius,
                            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
    
}
