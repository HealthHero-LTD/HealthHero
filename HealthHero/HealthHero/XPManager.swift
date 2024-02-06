//
//  XPManager.swift
//  HealthHero
//
//  Created by soroush kami on 2024-02-05.
//

import Foundation

struct XPManager {
    static func convertStepCountToXP(_ stepCount: Double) -> Int {
        var xp: Int = 0
        
        switch stepCount {
        case 0...500:
            xp = Int(stepCount / 40)
        case 501...2000:
            xp += 500 / 40
            xp += Int((stepCount - 500) / 30)
        case 2001...6000:
            xp += (500/40) + (1500/30)
            xp += Int((stepCount - 2000) / 25)
        case 6001...10000:
            xp += (500/40) + (1500/30) + (4000/25)
            xp += Int((stepCount - 6000) / 30)
        default:
            xp += (500/40) + (1500/30) + (4000/25) + (4000/30)
            xp += Int((stepCount - 10000) / 100)
        }
        
        return xp
    }
}
