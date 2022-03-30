//
//  ContentView.swift
//  Beacoffice
//
//  Created by Lorenzo Masucci on 30/03/2022.
//

import SwiftUI

struct ContentView: View {
    
    @State private var enableEmitter = true
    private var viewModel = ViewModel()

    var body: some View {
        VStack {
            
            
            Toggle("Enable Emitter", isOn: $enableEmitter)
            .onChange(of: enableEmitter) { value in
                viewModel.setBeaconState( value ? BeaconState.emitting : BeaconState.detecting)
            }
            
            VStack {
                if enableEmitter {
                    EmitterView()
                    
                } else {
                    DetectorView(viewModel: viewModel)
                }
            }
        }
    }
}

struct EmitterView: View {
            
    var body: some View {
        Text("Emitter")
    }
}

struct DetectorView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        Text("\(viewModel.detector.lastDistance.displayString)")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
