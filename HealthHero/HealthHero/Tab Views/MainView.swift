//
//  MainView.swift
//  HealthHero
//
//  Created by soroush kami on 2023-12-29.
//

import SwiftUI

struct MainView: View {
    @State private var selection = 2
    
    var body: some View {
        TabView(selection: $selection) {
            LeaderboardView()
                .tabItem {
                    Label("Leaderboard", systemImage: "trophy.circle")
                }
                .tag(0)
            StatsView()
                .tabItem {
                    Label("Stats", systemImage: "list.bullet.clipboard.fill")
                }
                .tag(1)
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle.fill")
                }
                .tag(2)
        }
    }
}

#Preview {
    MainView()
}
