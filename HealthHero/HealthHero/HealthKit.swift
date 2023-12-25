//
//  HealthKit.swift
//  HealthHero
//
//  Created by soroush kami on 2023-12-25.
//

import HealthKit

class HKManager {
    static func isHKAvailable () -> Bool {
        return HKHealthStore.isHealthDataAvailable()
    }
}

