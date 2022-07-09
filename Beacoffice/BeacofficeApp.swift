//
//  BeacofficeApp.swift
//  Beacoffice
//
//  Created by Lorenzo Masucci on 30/03/2022.
//

import SwiftUI
import ComposableArchitecture

@main
struct BeacofficeApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            BeaconDetectorView(store: Store(
                initialState: BeaconDetectorState(),
                reducer: beaconDetectorReducer,
                environment: .live(environment: BeaconDetectorEnvironment())))
        }
    }
}
