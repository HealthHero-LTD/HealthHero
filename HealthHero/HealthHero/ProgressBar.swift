//
//  ProgressBar.swift
//  HealthHero
//
//  Created by soroush kami on 2024-01-02.
//

import SwiftUI

struct ProgressBar: View {
    @State private var progress: Double = 0.5

    var body: some View {
        VStack {
            Text("Task Progress")

            // ProgressView with a binding to the progress value
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle())

            // Button to simulate progress update
            Button("Update Progress") {
                // Simulate progress update
                withAnimation {
                    progress += 0.1
                }
            }
            .padding()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar()
    }
}
