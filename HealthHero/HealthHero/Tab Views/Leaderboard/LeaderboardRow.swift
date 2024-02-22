//
//  LeaderboardRow.swift
//  HealthHero
//
//  Created by soroush kami on 2024-01-28.
//

import SwiftUI

struct LeaderboardRow: View {
    let entry: LeaderboardEntry
    
    var body: some View {
        HStack {
            Text("\(entry.id)")
                .frame(width: 25, alignment: .leading)
            Text(entry.username)
                .frame(maxWidth: .infinity, alignment: .center)
            Text("\(entry.level)")
                .frame(width: 25, alignment: .center)
            Text("\(entry.score)")
                .frame(width: 50, alignment: .center)
        }
    }
}
