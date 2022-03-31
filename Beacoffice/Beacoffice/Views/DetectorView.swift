//
//  DetectorView.swift
//  Beacoffice
//
//  Created by Lorenzo Masucci on 31/03/2022.
//

import SwiftUI

struct DetectorView: View {
    
    let beaconDetector = BeaconDetector()
    private let viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        Text(viewModel.distanceString ?? "")
    }
}
