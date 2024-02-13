//
//  LevelManager.swift
//  HealthHero
//
//  Created by soroush kami on 2024-02-11.
//

import Foundation

class LevelManager {
    static let shared = LevelManager()
    
    var userXP: Int = 0
    var currentLevel: Int = 1
    var requiredXPForNextLevel: Int = 1
    
    func updateUserXP(_ xp: Int) {
        userXP = xp
        checkLevelUp()
    }
    
    private func checkLevelUp() {
        while userXP >= requiredXPForNextLevel {
            levelUp()
        }
    }
    
    private func levelUp() {
        currentLevel += 1
        UserDefaultsManager.shared.setUserLevel(currentLevel)
        userXP -= requiredXPForNextLevel
        requiredXPForNextLevel *= 2
        checkLevelUp()
        print("You've reached level \(currentLevel)")
        print("new user xp:\(userXP)")
        print(requiredXPForNextLevel)
    }
}
