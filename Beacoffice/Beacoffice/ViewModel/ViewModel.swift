//
//  ViewModel.swift
//  Beacoffice
//
//  Created by Lorenzo Masucci on 30/03/2022.
//

import SwiftUI

class ViewModel: ObservableObject {
    
    @Published var distanceString: String?

    
    let officeUpdatesService: OfficeUpdatesService
    
    @Published var officeUpdate: OfficeUpdateData?
    
    init(officeUpdatesService: OfficeUpdatesService) {
        self.officeUpdatesService = officeUpdatesService
    }

    
    func checkService() {
        
        self.officeUpdatesService.fetchOfficeInfo(major: 1, minor: 1) { result in
            
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
        content.title = "Trainline Office"
        content.subtitle = data.someString
        content.sound = UNNotificationSound.default

        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)

    }
}
