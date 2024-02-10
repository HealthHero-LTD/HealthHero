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
    
    enum UserDefaultsError: Error {
        case lastActiveDateNotFound
    }
    
    func setLastActiveDate(_ date: Date) {
        userDefaults.set(date, forKey: lastActiveDateKey)
    }
    
    func getLastActiveDate() throws -> Date {
        if let lastActiveDate = userDefaults.object(forKey: lastActiveDateKey) as? Date {
            return lastActiveDate
        } else {
            throw UserDefaultsError.lastActiveDateNotFound
        }
    }
}
