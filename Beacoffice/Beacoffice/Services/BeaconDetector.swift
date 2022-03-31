//
//  BeaconDetector.swift
//  Beacoffice
//
//  Created by Oriol Ganduxe Pregona on 30/3/22.
//

import Foundation
import Combine
import CoreLocation

extension CLAuthorizationStatus {
    
    var isAuthorized: Bool {
        self == .authorizedAlways || self == .authorizedWhenInUse
    }
}

class BeaconDetector: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()

    
    private let constraint = CLBeaconIdentityConstraint(uuid: Constants.beaconUUID)
    private lazy var beaconRegion = CLBeaconRegion(beaconIdentityConstraint: constraint, identifier: Constants.beaconId)

    var distanceUpdated: ((CLProximity) -> Void)? = nil
    
    override init() {
        super.init()
        locationManager.delegate = self
        
        if locationManager.authorizationStatus.isAuthorized {
            startScanning()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager, status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse,
            CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self),
            CLLocationManager.isRangingAvailable() {
            // all ok
            startScanning()
        }
    }
    
    func startScanning() {
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(satisfying: constraint)
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        if let beacon = beacons.first {
            
            distanceUpdated?(beacon.proximity)
        }
    }
    
    func stopScanning() {
        locationManager.stopMonitoring(for: beaconRegion)
        locationManager.stopRangingBeacons(satisfying: constraint)
    }
}
