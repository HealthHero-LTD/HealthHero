//
//  LevelManager.swift
//  HealthHero
//
//  Created by soroush kami on 2024-02-11.
//

import Foundation

class LevelManager: ObservableObject {
    init(
        currentLevel: Int
    ) {
        self.userXP = 0
        self.currentLevel = currentLevel
        self.requiredXPForNextLevel = 1
        self.levelProgression = 0
    }
    
    var userXP: Int
    var currentLevel: Int
    var requiredXPForNextLevel: Int
    var levelProgression: Float
    
    func updateUserXP(_ xp: Int) {
        userXP = xp
        checkLevelUp()
        levelProgression = Float(userXP) / Float(requiredXPForNextLevel)
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
