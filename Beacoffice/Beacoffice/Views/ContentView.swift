//
//  ContentView.swift
//  Beacoffice
//
//  Created by Lorenzo Masucci on 30/03/2022.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    
    @ObservedObject var viewModel = ViewModel(officeUpdatesService: OfficeUpdatesFirebaseService(),
                                              beaconDetector: BeaconDetector())

    var body: some View {
        VStack {

            HeartView()
            Button(action: {
                print("Button pressed")
            }) {
                HStack {
                    Image(systemName: "bookmark.fill")
                    Text("Detector")
                }
            }
            .buttonStyle(GradientButtonStyle())
            
            VStack {
                DetectorView(viewModel: viewModel)
                Button("Test firebase") {
                    viewModel.checkService()
                }
                if let officeUpdate = viewModel.officeUpdate {
                    Text(officeUpdate.title)
                    Text(officeUpdate.body)
                    Text(officeUpdate.officeName)
                }
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct GradientButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.white)
            .padding()
            .background(Color.green)
//            .background(configuration.isPressed ? Color.green : Color.yellow)
//            .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(15.0)
            .scaleEffect(configuration.isPressed ? 1.3 : 1.0)
    }
}
