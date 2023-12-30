//
//  ContentView.swift
//  HealthHero
//
//  Created by soroush kami on 2023-12-18.
//

import SwiftUI

struct ContentView: View {
    @State private var stepCount: Double = .zero
    // Label -> icon text
    var body: some View {
        TabView {
            LeaderboardView()
                .tabItem { 
                    Label("Leaderboard", systemImage: "trophy.circle")
                }
            StatsView()
                .tabItem {
                    Label("Stats", systemImage: "list.number")
                }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle.fill")
                }
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
