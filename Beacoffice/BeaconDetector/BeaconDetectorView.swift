//
//  BeaconDetectorView.swift
//  Beacoffice
//
//  Created by Lorenzo Masucci on 30/03/2022.
//

import SwiftUI
import UserNotifications
import ComposableArchitecture

struct BeaconDetectorView: View {
    
//    @ObservedObject var viewModel = ViewModel(officeUpdatesService: OfficeUpdatesFirebaseService(),
//                                              beaconDetector: BeaconDetector())
    @State var messageReceived: Bool = false
//    @State var toggleDetector: Bool = true
    
    let store: Store<BeaconDetectorState, BeaconDetectorAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            ZStack {
                Color(viewStore.isScanning ? UIColor(red: 0.83, green: 0.95, blue: 0.91, alpha: 1.00) : UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1.00)).ignoresSafeArea()
                
                VStack {
                    if messageReceived {
                        
                        VStack {
                            MessageView(messageReceived: $messageReceived)
                        }
                    } else {
                        HStack {
                            Spacer()
                            Toggle("", isOn: viewStore.binding(get: { $0.isScanning },
                                                               send: { BeaconDetectorAction.enable($0) } ))
                            .toggleStyle(SwitchToggleStyle(tint: Color(UIColor(red: 0.14, green: 0.20, blue: 0.77, alpha: 1.00))))
                        }
                        .padding()
                        
                        Spacer()
                        
                        if viewStore.isScanning {
        
                            HeartView()
                                .padding(EdgeInsets(top: -30, leading: 0, bottom: 30, trailing: 0))
                            
                        } else {
                            Image("TrainlineHeart-greyed")
                                .resizable()
                                .frame(width: 144, height: 118.3)
                                .padding(EdgeInsets(top: -30, leading: 0, bottom: 30, trailing: 0))
                                
                        }
                        
                        Spacer()
                        
//                        if let officeUpdate = viewModel.officeUpdate {
//                            Text(officeUpdate.title)
//                            Text(officeUpdate.body)
//                            Text(officeUpdate.officeName)
//                        }
                    }
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BeaconDetectorView(store: Store(initialState: BeaconDetectorState(),
                                        reducer: beaconDetectorReducer,
                                        environment: .dev(environment: BeaconDetectorEnvironment(eventsService: BeaconEventsFirebaseService(),
                                                                                                 beaconDetector: BeaconDetector()))))
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
