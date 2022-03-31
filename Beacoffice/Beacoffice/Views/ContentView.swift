//
//  ContentView.swift
//  Beacoffice
//
//  Created by Lorenzo Masucci on 30/03/2022.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    
    @ObservedObject var beaconDetector = BeaconDetector()

    var body: some View {
        VStack {
            
            Button("Request Permission") {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        print("All set!")
                    } else if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }

            Button("Schedule Notification") {
                let content = UNMutableNotificationContent()
                content.title = "Trainline Office"
                content.subtitle = "Have a great day man!"
                content.sound = UNNotificationSound.default

                // show this notification five seconds from now
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

                // choose a random identifier
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                // add our notification request
                UNUserNotificationCenter.current().add(request)
                
            }
            
            
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
                DetectorView(beaconDetector: beaconDetector)
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
