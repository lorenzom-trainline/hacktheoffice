//
//  ViewModel.swift
//  Beacoffice
//
//  Created by Lorenzo Masucci on 30/03/2022.
//

import Foundation

class ViewModel: ObservableObject {
    
    let detector = BeaconDetector()
    let emitter = BeaconEmitter()
    
    let officeUpdatesService: OfficeUpdatesService
    
    @Published var officeUpdate: OfficeUpdateData?
    
    init(officeUpdatesService: OfficeUpdatesService) {
        self.officeUpdatesService = officeUpdatesService
    }
    
    func setBeaconState(_ state: BeaconState) {
        switch state {
        case .detecting:
            emitter.stopLocalBeacon()
            detector.startScanning()
        case .emitting:
            detector.stopScanning()
            emitter.startLocalBeacon()
        }
    }
    
    func checkService() {
        
        Task {
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
}

enum BeaconState {
    case detecting, emitting
}
