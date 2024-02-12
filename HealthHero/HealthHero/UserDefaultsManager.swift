//
//  UserDefaultsManager.swift
//  HealthHero
//
//  Created by soroush kami on 2024-02-09.
//

import Foundation

struct UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private let userDefaults = UserDefaults.standard
    private let lastActiveDateKey = "LastActiveDate"
    private let userLevelKey = "UserLevel"
    private let userXPKey = "UserXP"
    
    func setLastActiveDate(_ date: Date) {
        userDefaults.set(date, forKey: lastActiveDateKey)
    }
    
    func getLastActiveDate() -> Date {
        userDefaults.object(forKey: lastActiveDateKey) as! Date
    }
    
    func setUserLevel(level userLevel: Int) {
        userDefaults.set(userLevel, forKey: userLevelKey)
        print("user level saved in user defaults and is \(userLevel)")
    }
    
    func getUserLevel() -> Int {
        userDefaults.object(forKey: userLevelKey) as! Int
    }
    
    func setUserXP(_ userXP: Int) {
        userDefaults.set(userXP, forKey: userXPKey)
    }
    
    func getUserXP() -> Int {
        userDefaults.integer(forKey: userXPKey)
    }
}
