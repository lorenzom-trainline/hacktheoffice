//
//  HeartView.swift
//  Beacoffice
//
//  Created by Lorenzo Masucci on 31/03/2022.
//

import SwiftUI

struct HeartView: View {
    @State private var animationAmount: CGFloat = 1
    
    var body: some View {
        
        Image("TrainlineHeart")
            .resizable()
            .frame(width: 50, height: 50)
            .foregroundColor(.red)
            .scaleEffect(animationAmount)
            .animation(
                .linear(duration: 0.6)
                    .delay(0.1)
                    .repeatForever(autoreverses: true),
                value: animationAmount)
            .onAppear {
                animationAmount = 1.2
            }
        
    }
}

struct HeartView_Previews: PreviewProvider {
    static var previews: some View {
        HeartView()
    }
}
