//
//  DetectorView.swift
//  Beacoffice
//
//  Created by Lorenzo Masucci on 31/03/2022.
//

import SwiftUI

struct DetectorView: View {
    
    @ObservedObject var beaconDetector: BeaconDetector
    
    init(beaconDetector: BeaconDetector) {
        self.beaconDetector = beaconDetector
    }

    var body: some View {
        Text(beaconDetector.viewModel.distanceString ?? "")
    }
}
