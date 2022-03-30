//
//  ContentView.swift
//  Beacoffice
//
//  Created by Lorenzo Masucci on 30/03/2022.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        
        TabView {
            
            DetectorView()
                .tabItem {
                    Image(systemName: "circle.fill")
                }
            EmitterView(emitter: BeaconEmitter())
                .tabItem {
                    Image(systemName: "circle.fill")
                }
        }
    }
}

struct EmitterView: View {
        
    @State var emitter: BeaconEmitter
    
    var body: some View {
        
        Text("Emitter")
            .onAppear {
                emitter.initLocalBeacon()
            }
    }
    
}

struct DetectorView: View {
    
    @ObservedObject var detector = BeaconDetector()

    var body: some View {
        
        Text("\(detector.lastDistance.rawValue)")
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
