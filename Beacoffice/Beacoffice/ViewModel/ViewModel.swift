//
//  ViewModel.swift
//  Beacoffice
//
//  Created by Lorenzo Masucci on 30/03/2022.
//

import SwiftUI
import CoreLocation

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
                self.officeUpdate = update

            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
