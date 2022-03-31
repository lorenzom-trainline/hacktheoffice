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
    @State var messageReceived: Bool = true 
    
    var body: some View {
        ZStack {
            Color(UIColor(red: 0.83, green: 0.95, blue: 0.91, alpha: 1.00)).ignoresSafeArea()
            
            VStack {
                
                if messageReceived {
                    
                    VStack {
                        DetectorView(viewModel: viewModel)
                    }
                } else {
                    HeartView()
                    if let officeUpdate = viewModel.officeUpdate {
                        Text(officeUpdate.title)
                        Text(officeUpdate.body)
                        Text(officeUpdate.officeName)
                    }
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
