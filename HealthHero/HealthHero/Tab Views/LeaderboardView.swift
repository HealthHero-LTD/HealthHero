//
//  LeaderboardView.swift
//  HealthHero
//
//  Created by soroush kami on 2023-12-29.
//

import SwiftUI

struct LeaderboardView: View {
    let leaderboardEntries = [
        LeaderboardEntry(id: 1, username: "Player 1", level: 4, score: 100),
        LeaderboardEntry(id: 2, username: "Player 2", level: 4, score: 90),
        LeaderboardEntry(id: 3, username: "Player 3", level: 2, score: 80),
        LeaderboardEntry(id: 4, username: "Player 4", level: 3, score: 70),
    ]
    var body: some View {
        VStack {
            Text("Leaderboard")
                .font(.title)
                .padding()
            
            List(leaderboardEntries) { entry in
                LeaderboardRow(entry: entry)
            }
        }
    }
}

struct LeaderboardRow: View {
    let entry: LeaderboardEntry
    
    var body: some View {
        HStack {
            Text("\(entry.id)")
                .frame(width: 50, alignment: .leading)
            Text(entry.username)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("\(entry.score)")
                .frame(width: 50, alignment: .trailing)
        }
        .padding(.horizontal)
    }
}

#Preview {
    LeaderboardView()
}

struct LeaderboardEntry: Identifiable {
    let id: Int
    let username: String
    let level: Int
    let score: Int
}
