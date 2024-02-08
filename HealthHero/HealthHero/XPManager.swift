//
//  XPManager.swift
//  HealthHero
//
//  Created by soroush kami on 2024-02-05.
//

import Foundation

struct XPManager {
    static func convertStepCountToXP(_ stepCount: Double) -> Int {
        let rangeMin: Double = 500
        let rangeLow: Double = 2000
        let rangeHigh: Double = 6000
        let rangeMax: Double = 10000
        
        let valueMin: Double = 30
        let valueLow: Double = 35
        let valueHigh: Double = 40
        let valueMax: Double = 50
        
        var xp: Int = 0
        
        switch stepCount {
        case 0...rangeMin:
            xp = Int(stepCount / valueMin)
        case rangeMin+1...rangeLow:
            xp += Int(rangeMin / valueMin)
            xp += Int((stepCount - rangeMin) / valueLow)
        case rangeLow+1...rangeHigh:
            xp += Int(rangeMin / valueMin) + Int((rangeLow - rangeMin) / valueLow)
            xp += Int((stepCount - rangeLow) / valueHigh)
        case rangeHigh+1...rangeMax:
            xp += Int(rangeMin / valueMin) + Int((rangeLow - rangeMin) / valueLow) + Int((rangeHigh - rangeLow) / valueHigh)
            xp += Int((stepCount - rangeHigh) / valueMax)
        default:
            xp += Int(rangeMin / valueMin) + Int((rangeLow - rangeMin) / valueLow) + Int((rangeHigh - rangeLow) / valueHigh) + Int((rangeMax - rangeHigh) / valueMax)
            xp += Int((stepCount - rangeMax) / 100)
        }
        
        return xp
    }
}
