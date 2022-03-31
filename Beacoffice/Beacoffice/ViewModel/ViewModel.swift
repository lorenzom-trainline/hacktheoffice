//
//  ViewModel.swift
//  Beacoffice
//
//  Created by Lorenzo Masucci on 30/03/2022.
//

import SwiftUI

class ViewModel: ObservableObject {
    
    @Published var distanceString: String?
    @Published var officeUpdate: OfficeUpdateData? = nil
    
    private let officeUpdatesService: OfficeUpdatesService
    private let beaconDetector: BeaconDetector
    
    init(officeUpdatesService: OfficeUpdatesService, beaconDetector: BeaconDetector) {
        self.officeUpdatesService = officeUpdatesService
        self.beaconDetector = beaconDetector
        
        beaconDetector.distanceUpdated = { beacon in
            if self.lastBeaconDetected != beacon {
                self.lastBeaconDetected = beacon
                if let beacon = beacon {
                    self.checkService(major: beacon.major, minor: beacon.minor)
                }
            }
//            case .immediate:
//                self.distanceString = "Lava"
//            case .near:
//                self.distanceString = "Wind"
//            default:
//                self.distanceString = "Ice"
//            }
        }
    }
    
    func checkService(major: Int = 1, minor: Int = 1) {
        
        self.officeUpdatesService.fetchOfficeInfo(major: major, minor: minor) { result in
            
            switch result {
            case .success(let update):
                print(update)
                self.sendNotification(update)
                self.officeUpdate = update

            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func sendNotification(_ data: OfficeUpdateData) {
        let content = UNMutableNotificationContent()
        content.title = data.title
        content.subtitle = data.body
        content.sound = UNNotificationSound.default

        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)

    }
}
