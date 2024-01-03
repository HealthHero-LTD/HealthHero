//
//  HealthKit.swift
//  HealthHero
//
//  Created by soroush kami on 2023-12-25.
//

import HealthKit

@MainActor
class HKManager: ObservableObject {
    @Published var stepsCount: Double = .zero
    @Published var error: Error?
    
    let healthStore = HKHealthStore()
    let stepCountQuantityType = HKObjectType.quantityType(forIdentifier: .stepCount)
    
    func isHKAvailable() -> Bool {
        return HKHealthStore.isHealthDataAvailable()
    }
    
    func HKAuthorization() {
        guard isHKAvailable() else {
            print("Setup HealthKit")
            return
        }
        
        let allTypes = Set([stepCountQuantityType!])

        healthStore.requestAuthorization(toShare: allTypes, read: allTypes) { (success, error) in
            if !success {
                self.error = error
                print("Authorization failed. Error: \(error?.localizedDescription ?? "Unknown error")")
            } else {
                print("Authorization successful!")
            }
        }
    }
    
    func isAuthorized() -> Bool {
        if let quantityType = stepCountQuantityType {
            return healthStore.authorizationStatus(for: quantityType) == .sharingAuthorized
        } else {
            return false
        }
    }
    
    func readStepCount() {
        guard let stepQuantityType = stepCountQuantityType else { return }
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        
        let predicate = HKQuery.predicateForSamples(
            withStart: startOfDay,
            end: now,
            options: .strictStartDate
        )
        
        let query = HKStatisticsQuery(
            quantityType: stepQuantityType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { _, result, error in
            
            guard let result = result, let sum = result.sumQuantity() else {
                self.stepsCount = .zero
                return
            }
            
            self.stepsCount = sum.doubleValue(for: HKUnit.count())
        }
        
        healthStore.execute(query)
    }
}
