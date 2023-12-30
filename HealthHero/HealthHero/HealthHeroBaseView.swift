//
//  HealthHeroBaseView.swift
//  HealthHero
//
//  Created by soroush kami on 2023-12-29.
//

import SwiftUI

struct HealthHeroBaseView: View {
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
    }
}

#Preview {
    HealthHeroBaseView()
}
