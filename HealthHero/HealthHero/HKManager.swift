//
//  HealthKit.swift
//  HealthHero
//
//  Created by soroush kami on 2023-12-25.
//

import HealthKit

@MainActor
class HKManager: ObservableObject {
    @Published var error: Error?
    
    let healthStore = HKHealthStore()
    let stepCountQuantityType = HKObjectType.quantityType(forIdentifier: .stepCount)
    
    private func isHKAvailable() -> Bool {
        return HKHealthStore.isHealthDataAvailable()
    }
    
    func requestHealthKitAuthorization() {
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
    
    func readStepCount(completion: @escaping (Double) -> Void) {
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
                completion(.zero)
                return
            }
            
            completion(sum.doubleValue(for: HKUnit.count()))
        }
        
        healthStore.execute(query)
    }
    
    func readWeeklyStepCount(completion: @escaping ([StepsEntry]) -> Void) {
        let dummyData = [
            StepsEntry(day: "sun", stepCount: 100),
            StepsEntry(day: "mon", stepCount: 233),
            StepsEntry(day: "tue", stepCount: 190),
            StepsEntry(day: "wed", stepCount: 111),
            StepsEntry(day: "thu", stepCount: 11),
            StepsEntry(day: "fri", stepCount: 1020),
            StepsEntry(day: "sat", stepCount: 500)
        ]

        completion(dummyData)
    }
}
