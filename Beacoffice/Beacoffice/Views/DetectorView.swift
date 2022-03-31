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
        ZStack {
            Color(UIColor(red: 0.83, green: 0.95, blue: 0.91, alpha: 1.00)).ignoresSafeArea()
            
            VStack {
                Rectangle()
                    .padding()
                    .overlay(
                        ZStack {
                            VStack {
                                Color.white
                                Text(viewModel.distanceString ?? "")
                            }
                        }
                    )

            }
        }
    }
}
