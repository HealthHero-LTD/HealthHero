//
//  HealthKit.swift
//  HealthHero
//
//  Created by soroush kami on 2023-12-25.
//

import HealthKit

class HKManager: ObservableObject {
    
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
    
    static func isAuthorized() -> Bool {
        // Unwrapping optionals:
        // 1. Safely unwrap -> If object is nil, we get to decide what to do
        // 2. Force unwrap -> If object is nil, the app will crash
        
        // Safely unwrap
//        guard let quantityType = HKObjectType.quantityType(forIdentifier: .stepCount) else { return false }
        if let quantityType = HKObjectType.quantityType(forIdentifier: .stepCount) {
            return healthStore.authorizationStatus(for: quantityType) == .sharingAuthorized
        } else {
            return false
        }
    }
    
    static func readStepCount(completion: @escaping (Double) -> Void) {
        guard let stepQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0.0)
                return
            }
            
            completion(sum.doubleValue(for: HKUnit.count()))
        
        }
        
        healthStore.execute(query)
    }
}
