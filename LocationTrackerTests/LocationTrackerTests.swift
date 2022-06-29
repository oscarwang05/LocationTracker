//
//  LocationTrackerTests.swift
//  LocationTrackerTests
//
//  Created by Yan Wang on 28/06/2022.
//

import XCTest
@testable import LocationTracker
import CoreLocation

class LocationTrackerTests: XCTestCase {

    var locations : [CLLocation] = []
    
    /*
        This is a test for following purpose:
     1. when there are multiple locations in variable "locations", only the first location and last location has a distance greater than 10 metres. The location coordinates were from simulation running
     2. After detecting moving of 10 metres, the location array will be emptied and append only the most current location for future distance calculation
     */
    
    func testGetLocation(){
        
        let location1 = CLLocation(latitude: 37.33077759, longitude: -122.03056052)
        let location2 = CLLocation(latitude: 37.33074980, longitude: -122.03054302)
        let location3 = CLLocation(latitude: 37.33072336, longitude: -122.03051790)
        let location4 = CLLocation(latitude: 37.33070920, longitude: -122.03048122)
        
        locations.append(location1)
        locations.append(location2)
        locations.append(location3)
        locations.append(location4)

        XCTAssert(location1.distance(from: location2) < 10, "This distance should be less than 10 metres")
        
        XCTAssert(location2.distance(from: location3) < 10, "This distance should be less than 10 metres")
        
        XCTAssert(location1.distance(from: location3) < 10, "This distance should be less than 10 metres")
        
        XCTAssert(location1.distance(from: location4) >= 10, "This distance should be greater than 10 metres")
            
        guard let currentLocation = self.locations.last, let lastLocation = self.locations.first else {
            return
        }
            
        let distance = currentLocation.distance(from: lastLocation)
    
        if distance > 10 {
            self.locations.removeAll()
                
            XCTAssert(self.locations.isEmpty, "The array should be empty now")
                
            self.locations.append(currentLocation)
                
            XCTAssert(self.locations.count == 1, "The array should have only 1 element which is the current location")
            XCTAssert(self.locations.first == location4, "The only element should be the most current location")
        }
    }
}
