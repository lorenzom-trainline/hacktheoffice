//
//  BeaconDetectorFeature.swift
//  Beacoffice
//
//  Created by Oriol Ganduxé Pregona on 9/7/22.
//

import Combine
import ComposableArchitecture

struct BeaconDetectorState: Equatable {
    var isScanning = false
    var currentEvents: [Event] = []
}

enum BeaconDetectorAction {
    case onAppear
    case enable(Bool)
    case showError(Error?) // TODO: dont allow nil
    case beaconDetected(BeaconId)
    case eventsDetected([Event])
}

struct BeaconDetectorEnvironment {
    
    var eventsService: BeaconEventsService
    var beaconDetector: BeaconDetector
}

let beaconDetectorReducer = Reducer<
    BeaconDetectorState,
    BeaconDetectorAction,
    SystemEnvironment<BeaconDetectorEnvironment>>
{ state, action, environment in
    
    switch action {
    case .onAppear:
//        state.isScanning = true
//        return Effect(value: .enable(true))
        ()
        
    case .enable(let enable):
        state.isScanning = enable
        
        if enable {
            
            environment.beaconDetector.startScanning()
            
            // TODO: Subscribing each time causes problems
            return environment.beaconDetector.publisher
//                .subscribe(on: environment.mainQueue())
                .receive(on: environment.mainQueue())
                .map { beacon in BeaconDetectorAction.beaconDetected(BeaconId(major: beacon.major,
                                                                              minor: beacon.minor)) }
                .replaceError(with: BeaconDetectorAction.showError(nil))
                .eraseToEffect()
        } else {
            environment.beaconDetector.stopScanning()
        }

    case .showError(let error):
        state.isScanning = false
        // TODO: Handle error
        
    case .beaconDetected(let beaconId):
        
        return environment.eventsService.fetchEventsPublisher(beaconId: beaconId)
            .receive(on: environment.mainQueue())
            .map { events in BeaconDetectorAction.eventsDetected(events) }
            .replaceError(with: BeaconDetectorAction.showError(nil))
            .eraseToEffect()
        
    case .eventsDetected(let events):
        print(events)
        ()
        // TODO
    }
    
    return .none
}
