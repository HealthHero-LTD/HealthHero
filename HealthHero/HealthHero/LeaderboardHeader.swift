//
//  LeaderboardHeader.swift
//  HealthHero
//
//  Created by soroush kami on 2024-01-28.
//

import SwiftUI

struct LeaderboardHeader: View {
    var body: some View {
        HStack {
            Text("#")
                .fontWeight(.bold)
                .frame(width: 25, alignment: .leading)
            Text("Hero")
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
            Text("LVL")
                .fontWeight(.bold)
                .frame(width: 30, alignment: .center)
            Text("Score")
                .fontWeight(.bold)
                .frame(width: 50, alignment: .center)
        }
    }
}
