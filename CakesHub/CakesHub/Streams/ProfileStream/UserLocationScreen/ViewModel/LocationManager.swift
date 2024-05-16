//
//
//  LocationManager.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 13.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Observation
import CoreLocation
import MapKit

@Observable
class LocationManager: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
    var mapView: MKMapView = .init()
    var manager: CLLocationManager = .init()
    var userLocation: CLLocationCoordinate2D?

    override init() {
        super.init()
        manager.delegate = self
        mapView.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
}

// MARK: - MKMapViewDelegate

extension LocationManager {

    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        // Handle error
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.last?.coordinate
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .denied:
            handleLocationError()
        case .authorizedAlways:
            manager.requestLocation()
        case .authorizedWhenInUse:
            manager.requestLocation()
        default: ()
        }
    }

    func handleLocationError() {}
}
