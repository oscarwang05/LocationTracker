//
//  ViewController.swift
//  LocationTracker
//
//  Created by Milo on 28/06/2022.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    var distance : CLLocationDistance?
    
    let mapView = MKMapView()
    let blankView = UIView()
    let label = UILabel()
    
    var locations : [CLLocation] = []
    
    func getDistance() {
        LocationManager.shared.getCurrentLocation { [weak self] location in
            
            guard let strongSelf = self else {
                return
            }
            strongSelf.mapView.centerToLocation(location)
            strongSelf.locations.append(location)
            
            guard let currentLocation = strongSelf.locations.last, let lastLocation = strongSelf.locations.first else {
                return
            }
            
            let distance = currentLocation.distance(from: lastLocation)
            if distance > 10 {
                #if DEBUG
                print("You have moved \(distance) metres from your previous location" )
                #endif
                strongSelf.label.text = "You have moved \(distance) metres from your previous location"
                strongSelf.locations.removeAll()
                strongSelf.locations.append(currentLocation)
            }
            else {
                strongSelf.label.text = ""
            }
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        mapView.showsUserLocation = true
        mapView.showsScale = true
        mapView.showsCompass = true
        
        self.view.addSubview(mapView)
        self.view.addSubview(blankView)
        self.view.addSubview(label)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (LocationManager.shared.manager.authorizationStatus == .restricted || LocationManager.shared.manager.authorizationStatus == .denied) {
            label.text = """
                Please go to Setting -> Privacy -> Location Service -> LocationTracker and select "while using app" or "always"
                """
            let alert = UIAlertController(title: "Location Service Not Available",
                                          message: """
                Location Service not available. Please go to Setting -> Privacy -> Location Service -> LocationTracker and select "while using app" or "always"
                """,
                                          preferredStyle: .alert)
            let okbutton = UIAlertAction(title: "OK", style: .cancel)
            alert.addAction(okbutton)
            self.present(alert, animated: true)
        }
        else {
            getDistance()
        }
    }
    
    override func viewWillLayoutSubviews() {
        mapView.frame = self.view.bounds
        
        blankView.frame = CGRect(x: 30,
                                 y: self.view.frame.height - 250,
                                 width: self.view.frame.width - 60,
                                 height: 150)
        blankView.backgroundColor = .white
        blankView.layer.cornerRadius = 20
        blankView.layer.opacity = 0.5
        
        label.numberOfLines = 0
        label.frame = CGRect(x: blankView.frame.origin.x + 20, y: blankView.frame.origin.y, width: blankView.frame.width - 40, height: blankView.frame.height)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
    }
}

