//
//  User.swift
//  HealthHero
//
//  Created by soroush kami on 2024-02-03.
//

import Foundation

struct User: Codable {
    var level: Int
    var xp: Int
    var lastActiveDate: Date?
    var xpDataArray: [XPData] = []
}
