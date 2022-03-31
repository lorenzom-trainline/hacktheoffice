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
    @Published var lastDistance = CLProximity.unknown
    @Published var viewModel: ViewModel = ViewModel(officeUpdatesService: OfficeUpdatesFirebaseService())
    
    private let constraint = CLBeaconIdentityConstraint(uuid: Constants.beaconUUID)
    private lazy var beaconRegion = CLBeaconRegion(beaconIdentityConstraint: constraint, identifier: Constants.beaconId)

    
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
            updateDistance(beacon.proximity)
            
            switch beacon.proximity {
            case .immediate:
                viewModel.distanceString = "Lava"
            case .near:
                viewModel.distanceString = "Wind"
            default:
                viewModel.distanceString = "Ice"
            }
        }
    }
    
    func stopScanning() {
        locationManager.stopMonitoring(for: beaconRegion)
        locationManager.stopRangingBeacons(satisfying: constraint)
    }

    func updateDistance(_ distance: CLProximity) {
        lastDistance = distance
        print(distance.rawValue)
    }
}
