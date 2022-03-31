//
//  ViewModel.swift
//  Beacoffice
//
//  Created by Lorenzo Masucci on 30/03/2022.
//

import Foundation

class ViewModel: ObservableObject {
    let detector = BeaconDetector()
    let emitter = BeaconEmitter()
    
    
    
    func setBeaconState(_ state: BeaconState) {
        switch state {
        case .detecting:
            emitter.stopLocalBeacon()
            detector.startScanning()
        case .emitting:
            detector.stopScanning()
            emitter.startLocalBeacon()
        }
    }
}

enum BeaconState {
    case detecting, emitting
}
