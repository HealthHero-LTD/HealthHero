//
//  LeaderboardView.swift
//  HealthHero
//
//  Created by soroush kami on 2023-12-29.
//

import SwiftUI

struct LeaderboardView: View {
    let leaderboardEntries = [
        LeaderboardEntry(id: 1, username: "Player 1", level: 5, score: 100),
        LeaderboardEntry(id: 2, username: "Player 2", level: 4, score: 90),
        LeaderboardEntry(id: 3, username: "Player 3", level: 3, score: 80),
        LeaderboardEntry(id: 99, username: "Player 4", level: 2, score: 70),
    ]
    
    var body: some View {
        VStack {
            Text("Leaderboard")
                .font(.title)
                .padding()
            
            List {
                HeaderRow()
                ForEach(leaderboardEntries) { entry in
                    LeaderboardRow(entry: entry)
                }
            }
        }
    }
}

struct HeaderRow: View {
    var body: some View {
        HStack {
            Text("#")
                .fontWeight(.bold)
                .frame(width: 25, alignment: .leading)
            Text("Hero")
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("LVL")
                .fontWeight(.bold)
                .frame(width: 30, alignment: .trailing)
            Text("Score")
                .fontWeight(.bold)
                .frame(width: 50, alignment: .trailing)
        }
        .padding(.horizontal)
    }
}


struct LeaderboardRow: View {
    let entry: LeaderboardEntry
    
    var body: some View {
        HStack {
            Text("\(entry.id)")
                .frame(width: 25, alignment: .leading)
            Text(entry.username)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("\(entry.level)")
                .frame(width: 25, alignment: .leading)
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
