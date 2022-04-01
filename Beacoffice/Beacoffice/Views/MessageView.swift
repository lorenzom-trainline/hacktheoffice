//
//  DetectorView.swift
//  Beacoffice
//
//  Created by Lorenzo Masucci on 31/03/2022.
//

import SwiftUI

struct MessageView: View {
    
    let beaconDetector = BeaconDetector()
    private let viewModel: ViewModel
    @Binding var messageReceived: Bool
    
    init(viewModel: ViewModel, messageReceived: Binding<Bool>) {
        self.viewModel = viewModel
        self._messageReceived = messageReceived
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
                                        print("close")
                                        messageReceived = false
                                    } label: {
                                        Image(systemName: "xmark")
                                            .font(Font.title3.weight(.bold))
                                            .foregroundColor(.black)
                                            .padding()
                                    }
                                }
                                Spacer()
                                Text(viewModel.distanceString ?? "We're blasting off 🚀")
                                    .font(Font.title2.weight(.bold))
                                Text("Add something about Trainline here you can decide, keep it short and sweet!")
                                    .font(Font.body.weight(.medium))
                                    .padding()
                                
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
