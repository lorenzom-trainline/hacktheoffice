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
    
    var didChange = PassthroughSubject<Void, Never>()
    var locationManager = CLLocationManager()
    @Published var lastDistance = CLProximity.unknown
    
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
        
        let constraint = CLBeaconIdentityConstraint(uuid: Constants.beaconUUID)
        let beaconRegion = CLBeaconRegion(beaconIdentityConstraint: constraint, identifier: Constants.beaconId)

        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(satisfying: constraint)
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        if let beacon = beacons.first {
            updateDistance(beacon.proximity)
        }
    }

    func updateDistance(_ distance: CLProximity) {
        lastDistance = distance
        print(distance.rawValue)
        didChange.send(())
    }
}
