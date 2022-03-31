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

struct LocalBeacon: Equatable {
    let major: Int
    let minor: Int
}

extension CLBeacon {
    var localBeacon: LocalBeacon {
        .init(major: major.intValue, minor: minor.intValue)
    }
}

class BeaconDetector: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()

    
    private let constraint = CLBeaconIdentityConstraint(uuid: Constants.beaconUUID)
    private lazy var beaconRegion = CLBeaconRegion(beaconIdentityConstraint: constraint, identifier: Constants.beaconId)

    var distanceUpdated: ((LocalBeacon?) -> Void)? = nil
    
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
        
        distanceUpdated?(beacons.filter { $0.proximity != .unknown }.first?.localBeacon)
    }
    
    func stopScanning() {
        locationManager.stopMonitoring(for: beaconRegion)
        locationManager.stopRangingBeacons(satisfying: constraint)
    }
}
