//
//  LevelManager.swift
//  HealthHero
//
//  Created by soroush kami on 2024-02-11.
//

import Foundation

class LevelManager: ObservableObject {
    init(
        currentLevel: Int,
        userXP: Int
    ) {
        self.userXP = userXP
        self.currentLevel = currentLevel
        self.requiredXPForNextLevel = 1
    }
    
    var userXP: Int
    var currentLevel: Int
    var requiredXPForNextLevel: Int
    var levelProgression: Float {
        Float(userXP) / Float(requiredXPForNextLevel)
    }
    
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
        userXP -= requiredXPForNextLevel
        requiredXPForNextLevel *= 2
        checkLevelUp()
    }
}
