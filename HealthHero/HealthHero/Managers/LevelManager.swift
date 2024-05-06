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
    }
    
    var userXP: Int
    var currentLevel: Int
    var levelProgression: Float {
        Float(userXP) / Float(requiredXPForNextLevel(currentLevel))
    }
    
    func updateUserXP(_ xp: Int) {
        userXP = xp
        checkLevelUp()
    }
    
    private func checkLevelUp() {
        while userXP >= requiredXPForNextLevel(self.currentLevel) {
            levelUp()
        }
    }
    
    private func levelUp() {
        userXP -= requiredXPForNextLevel(self.currentLevel)
        currentLevel += 1
    }

    private func requiredXPForNextLevel(_ currentLevel: Int) -> Int {
        switch currentLevel {
        case 1...5:
            return 100
        case 6...10:
            return 200
        case 11...20:
            return 500
        default:
            return 1000
        }
    }
}
