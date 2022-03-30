//
//  BeaconEmitter.swift
//  Beacoffice
//
//  Created by Oriol Ganduxe Pregona on 30/3/22.
//

import Foundation
import CoreLocation
import CoreBluetooth

class BeaconEmitter: NSObject, CBPeripheralManagerDelegate {
    
    var localBeacon: CLBeaconRegion!
    var beaconPeripheralData: NSDictionary!
    var peripheralManager: CBPeripheralManager!

     func initLocalBeacon() {
         if localBeacon != nil {
             stopLocalBeacon()
         }
         
         let constraint = CLBeaconIdentityConstraint(uuid: Constants.beaconUUID)
         localBeacon = CLBeaconRegion(beaconIdentityConstraint: constraint, identifier: Constants.beaconId)

         // beaconPeripheralData = localBeacon.peripheralData(withMeasuredPower: nil)
         beaconPeripheralData = ["foo": "bar"]
         peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
     }

     func stopLocalBeacon() {
         peripheralManager.stopAdvertising()
         peripheralManager = nil
         beaconPeripheralData = nil
         localBeacon = nil
     }

    @objc func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
         if peripheral.state == .poweredOn {
             peripheralManager.startAdvertising(beaconPeripheralData as? [String: Any])
         } else if peripheral.state == .poweredOff {
             peripheralManager.stopAdvertising()
         }
     }
    
}
