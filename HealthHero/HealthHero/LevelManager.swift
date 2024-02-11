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
    var requiredXPForNextLevel: Int = 100
    
    func updateUserXP(_ xp: Int) {
        userXP = xp
        checkLevelUp()
    }
    
    private func checkLevelUp() {
        if userXP >= requiredXPForNextLevel {
            levelUp()
        }
    }
    
    private func levelUp() {
        currentLevel += 1
        requiredXPForNextLevel *= 2 // double the required XP for the next level
        UserDefaultsManager.shared.setUserLevel(level: currentLevel)
        print("You've reached level \(currentLevel)")
        print(userXP)
        print(requiredXPForNextLevel)
    }
}
