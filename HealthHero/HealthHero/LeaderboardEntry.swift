//
//  LeaderboardEntry.swift
//  HealthHero
//
//  Created by soroush kami on 2024-01-28.
//

import SwiftUI

struct LeaderboardEntry: Identifiable, Codable {
    let id: Int
    let username: String
    let level: Int
    let score: Int
}
