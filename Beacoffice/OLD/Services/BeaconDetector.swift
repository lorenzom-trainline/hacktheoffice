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

// TODO: Unity LocalBeacon and BeaconId
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
    
    private let passPublisher: PassthroughSubject<LocalBeacon, Error>
    var publisher: AnyPublisher<LocalBeacon, Error>
    
    override init() {
        
        passPublisher = PassthroughSubject<LocalBeacon, Error>()
        publisher = passPublisher.eraseToAnyPublisher()
        
        super.init()
        locationManager.delegate = self
        
        if locationManager.authorizationStatus.isAuthorized {
//            startScanning()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        
//        passPublisher.handleEvents(receiveSubscription: { [weak self] _ in
//            self?.wantToScan = true
//            print("subscription")
//        }, receiveCompletion: { _ in
//            print("completion")
//        }, receiveCancel: {
//            print("cancellation")
//        })
    }
        
    // MARK - delegate methods
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager, status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse,
            CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self),
            CLLocationManager.isRangingAvailable() {
            // all ok
//            startScanning()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        if let beacon = beacons.filter({ $0.proximity != .unknown }).first?.localBeacon {
            passPublisher.send(beacon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        passPublisher.send(completion: Subscribers.Completion.failure(error))
    }
    
    // MARK - private methods
    
    func startScanning() {
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(satisfying: constraint)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.passPublisher.send(LocalBeacon(major: 1, minor: 1))
        }
    }
    
    func stopScanning() {
        locationManager.stopMonitoring(for: beaconRegion)
        locationManager.stopRangingBeacons(satisfying: constraint)
    }
}
