//
//  OfficeUpdatesService.swift
//  Beacoffice
//
//  Created by Oriol Ganduxe Pregona on 31/3/22.
//

import Foundation

struct OfficeInfoData {
    
    let someString: String
}

protocol OfficeUpdatesService {
    func fetchOfficeInfo(major: Int, minor: Int) async -> OfficeInfoData
}

class OfficeUpdatesFakeService: OfficeUpdatesService {
    
    func fetchOfficeInfo(major: Int, minor: Int) async -> OfficeInfoData {
        
        // Here we would be fetching in firebase
        return OfficeInfoData(someString: "Bla bla bla")
    }
}
