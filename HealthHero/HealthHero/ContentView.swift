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
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            
            if HKManager.isHKAvailable() {
                Text("HealthKit is available!")
            }
            else {
                Text("HealthKit is not available, check the configuration!")
            }
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
