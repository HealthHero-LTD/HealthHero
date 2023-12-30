//
//  ContentView.swift
//  HealthHero
//
//  Created by soroush kami on 2023-12-18.
//

import SwiftUI

struct ContentView: View {
    @State private var stepCount: Double = .zero
    var body: some View {
        VStack {
            Text("You took \(stepCount) steps today.")
            
            if HKManager.isHKAvailable() {
                Text("HealthKit is available!")
            }
            else {
                Text("HealthKit is not available, check the configuration!")
            }
            
            Button {
                HKManager.HKAuthorization()
            } label: {
                Text("Authorize HealthKit")
                    .padding(10)
                    .foregroundColor(.white)
            }
            .background(.color1)
            .cornerRadius(10)
            
        }
        .onAppear {
            HKManager.readStepCount { stepCount in
                self.stepCount = stepCount
            }
        }
    }

}

#Preview {
    ContentView()
}
