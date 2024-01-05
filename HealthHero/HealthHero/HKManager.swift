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
    
//    func readStepCount(for date: Date, completion: @escaping (Double) -> Void) {
//        guard let stepQuantityType = stepCountQuantityType else { return }
//        let now = Date()
//        let startOfDay = Calendar.current.startOfDay(for: now)
//        
//        let predicate = HKQuery.predicateForSamples(
//            withStart: startOfDay,
//            end: now,
//            options: .strictStartDate
//        )
//        
//        let query = HKStatisticsQuery(
//            quantityType: stepQuantityType,
//            quantitySamplePredicate: predicate,
//            options: .cumulativeSum
//        ) { _, result, error in
//            
//            guard let result = result, let sum = result.sumQuantity() else {
//                completion(.zero)
//                return
//            }
//            
//            completion(sum.doubleValue(for: HKUnit.count()))
//        }
//        
//        healthStore.execute(query)
//    }
    
    func readStepCount(for date: Date, completion: @escaping (Double) -> Void) {
        guard let stepQuantityType = stepCountQuantityType else { return }

        let startOfDay = Calendar.current.startOfDay(for: date)
        let endOfDay = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: date) ?? date

        let predicate = HKQuery.predicateForSamples(
            withStart: startOfDay,
            end: endOfDay,
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
        guard let stepQuantityType = stepCountQuantityType else { return }
        
        let calendar = Calendar.current
        let now = Date()
        
        guard let lastWeekStartDate = calendar.date(byAdding: .weekOfYear, value: -1, to: now),
              let lastWeekEndDate = calendar.date(byAdding: .day, value: 0, to: now) else {
            completion([])
            return
        }
        
        var weeklyStepData: [StepsEntry] = []
        
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: i, to: lastWeekStartDate) {
                let dayString = calendar.shortWeekdaySymbols[calendar.component(.weekday, from: date) - 1].lowercased()
                
                // Fetch real step count from HKManager
                readStepCount(for: date) { stepsCount in
                    let stepsEntry = StepsEntry(day: dayString, stepCount: stepsCount, date: date)
                    weeklyStepData.append(stepsEntry)
                    
                    // If all entries are fetched, call the completion handler
                    if weeklyStepData.count == 7 {
                        completion(weeklyStepData)
                    }
                }
            }
        }
    }
}
