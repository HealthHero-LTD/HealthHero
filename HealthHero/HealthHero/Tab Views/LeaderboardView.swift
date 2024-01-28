//
//  LeaderboardView.swift
//  HealthHero
//
//  Created by soroush kami on 2023-12-29.
//

import SwiftUI

struct LeaderboardView: View {
    @ObservedObject var leaderboardViewModel = LeaderboardViewModel()
    
    var body: some View {
        VStack {
            Text("Leaderboard")
                .font(.title)
                .padding()
            
            List {
                LeaderboardHeader()
                ForEach(leaderboardViewModel.leaderboardEntries) { entry in
                    LeaderboardRow(entry: entry)
                }
            }
            Button("Refresh") {
                leaderboardViewModel.refreshLeaderboardData()
            }
            .padding()
        }
        .onAppear() {
            leaderboardViewModel.loadCachedData()
        }
    }
}

#Preview {
    LeaderboardView()
}
