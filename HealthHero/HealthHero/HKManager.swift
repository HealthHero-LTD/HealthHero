//
//  HealthKit.swift
//  HealthHero
//
//  Created by soroush kami on 2023-12-25.
//

import HealthKit

class HKManager {
    
    static let healthStore = HKHealthStore()
    
    static func isHKAvailable() -> Bool {
        return HKHealthStore.isHealthDataAvailable()
    }
    
    static func HKAuthorization() {
        guard isHKAvailable() else {
            print("Setup HealthKit")
            return
        }
        
        let allTypes = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!])

        healthStore.requestAuthorization(toShare: allTypes, read: allTypes) { (success, error) in
            if !success {
                print("Authorization failed. Error: \(error?.localizedDescription ?? "Unknown error")")
            } else {
                print("Authorization successful!")
            }
        }
    }
}
