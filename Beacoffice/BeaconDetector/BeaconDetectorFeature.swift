//
//  BeaconDetectorFeature.swift
//  Beacoffice
//
//  Created by Oriol Ganduxé Pregona on 9/7/22.
//

import Combine
import ComposableArchitecture

struct BeaconDetectorState: Equatable {
    var isScanning: Bool = true
    var currentUpdate: OfficeUpdateData? = nil
}

enum BeaconDetectorAction: Equatable {
    case onAppear
    case enable(Bool)
    case beaconDetected([OfficeUpdateData])
}

struct BeaconDetectorEnvironment {
    
    // TODO: Need them to return effects
//    var officeUpdatesService: OfficeUpdatesService
//    var beaconDetector: BeaconDetector
}

let beaconDetectorReducer = Reducer<
    BeaconDetectorState,
    BeaconDetectorAction,
    SystemEnvironment<BeaconDetectorEnvironment>>
{ state, action, environment in
    
    switch action {
    case .onAppear:
        state.isScanning = true
        return Effect(value: .enable(true))
        
    case .enable(let enable):
        state.isScanning = enable
        // TODO: toggle beacon detector to start/stop scanning
        
    case .beaconDetected(let updates):
        ()
        // TODO: use offficeUpdatesServices
    }
    
    return .none
}
