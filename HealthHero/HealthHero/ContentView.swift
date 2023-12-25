//
//  ContentView.swift
//  HealthHero
//
//  Created by soroush kami on 2023-12-18.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            
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
    }

}

#Preview {
    ContentView()
}
