//
//  BeacofficeApp.swift
//  Beacoffice
//
//  Created by Lorenzo Masucci on 30/03/2022.
//

import SwiftUI

@main
struct BeacofficeApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
