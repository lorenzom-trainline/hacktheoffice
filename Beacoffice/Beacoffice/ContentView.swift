//
//  ContentView.swift
//  Beacoffice
//
//  Created by Lorenzo Masucci on 30/03/2022.
//

import SwiftUI
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
        let uuid = UUID(uuidString: "734fe6d8-d91d-4838-9ef1-8be0734524a5")!
        let constraint = CLBeaconIdentityConstraint(uuid: uuid, major: 6282, minor: 6282)
        let beaconRegion = CLBeaconRegion(beaconIdentityConstraint: constraint, identifier: "MyBeacon")


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

struct ContentView: View {
    @ObservedObject var detector = BeaconDetector()
    
    var body: some View {
        Text("\(detector.lastDistance.rawValue)")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
