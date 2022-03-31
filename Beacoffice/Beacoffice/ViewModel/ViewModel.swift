//
//  ViewModel.swift
//  Beacoffice
//
//  Created by Lorenzo Masucci on 30/03/2022.
//

import SwiftUI

class ViewModel: ObservableObject {
    
    @Published var distanceString: String?
    @Published var officeUpdate: OfficeUpdateData = OfficeUpdateData(someString: "")
    
    private let officeUpdatesService: OfficeUpdatesService
    private let beaconDetector: BeaconDetector
    
    init(officeUpdatesService: OfficeUpdatesService, beaconDetector: BeaconDetector) {
        self.officeUpdatesService = officeUpdatesService
        self.beaconDetector = beaconDetector
        
        beaconDetector.distanceUpdated = { proximity in
            
            switch proximity {
            case .immediate:
                self.distanceString = "Lava"
            case .near:
                self.distanceString = "Wind"
            default:
                self.distanceString = "Ice"
            }
        }
    }

    func checkService() {
        
        self.officeUpdatesService.fetchOfficeInfo(major: 1, minor: 1) { result in
            
            switch result {
            case .success(let update):
                print(update)
                self.officeUpdate = update

            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
