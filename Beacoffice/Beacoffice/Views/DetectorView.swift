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
    @Binding var close: Bool = false
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            Color(UIColor(red: 0.83, green: 0.95, blue: 0.91, alpha: 1.00)).ignoresSafeArea()
            
            VStack {
                Rectangle()
                    .overlay(
                        ZStack {
                            Color.white
                            VStack {
                                HStack {
                                    Spacer()
                                    Button {
                                        close = true
                                        print("close")
                                    } label: {
                                        Image(systemName: "xmark")
                                            .font(Font.title3.weight(.bold))
                                            .foregroundColor(.black)
                                            .padding()
                                    }
                                }
                                Spacer()
                                Text(viewModel.distanceString ?? "Test")
                                
                                Spacer()
                            }
                        }
                    )
                    .frame(height: 200)
                    .padding(.horizontal)

            }
        }
    }
}
