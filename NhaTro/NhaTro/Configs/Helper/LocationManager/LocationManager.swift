//
//  LocationManager.swift
//  NhaTro
//
//  Created by HOANGHUNG on 1/3/18.
//  Copyright © 2018 HOANG HUNG. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    
    // MARK: - Singleton
    static let shared: LocationManager = LocationManager()
    
    // MARK - VAriables
    fileprivate let locationManager = CLLocationManager()
    fileprivate var currentLocation: ((_ location: CLLocationCoordinate2D?,_ error: String?)->())?
    
    func setup() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
    }
    
    func startUpdateLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdateLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func getCurrentLocation(_ completion: ((_ location: CLLocationCoordinate2D?,_ error: String?)->())?) {
        currentLocation = completion
        startUpdateLocation()
    }
}

// MARK: - Location Manager Delegate
extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            currentLocation!(nil, "Không thể lấy được vị trí!")
            return
        }
        let location2D = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        guard let currentLocation = currentLocation else { return }
        currentLocation(location2D, nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let currentLocation = currentLocation else { return }
        currentLocation(nil, error.localizedDescription)
    }
    
}
