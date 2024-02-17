//
//  UserInfo.swift
//  HealthHero
//
//  Created by soroush kami on 2024-02-15.
//

import Foundation

struct UserInfo: Codable {
    var level: Int = 1
    var username: String = ""
    var xp: Int = 0
    var lastActiveDate: Date?
}
