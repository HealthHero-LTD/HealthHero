//
//  UserInfo.swift
//  HealthHero
//
//  Created by soroush kami on 2024-02-15.
//

import Foundation

struct UserInfo: Codable {
    var level: Int
    var username: String
    var xp: Int
    var lastActiveDate: Date?
//    var xpDataArray: [XPData] = []
}
