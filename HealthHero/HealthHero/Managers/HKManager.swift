//
//  HealthKit.swift
//  HealthHero
//
//  Created by soroush kami on 2023-12-25.
//

import HealthKit

enum HKError: Error {
    case healthDataNotAvailable
}

class HKManager: ObservableObject {
    @Published var error: Error?
    @Published var stepsEntries: [StepsEntry] = []
    
    var healthStore: HKHealthStore?
    let stepCountQuantityType = HKObjectType.quantityType(forIdentifier: .stepCount)
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        } else {
            error = HKError.healthDataNotAvailable
        }
    }
    
    func requestHealthKitAuthorization() async {
        guard let stepType = stepCountQuantityType else { return }
        guard let healthStore = self.healthStore else { return }
        
        do {
            try await healthStore.requestAuthorization(toShare: [], read: [stepType])
        } catch {
            self.error = error
        }
    }
        
    func calculateSteps(from startDate: Date) async throws {
        
        guard let healthStore = self.healthStore else { return }
        let endDate: Date = Date().localDate()
        let stepType = HKQuantityType(.stepCount)
        let everyDay = DateComponents(day:1)
        let thisWeek = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let stepsThisWeek = HKSamplePredicate.quantitySample(type: stepType, predicate:thisWeek)
        
        let sumOfStepsQuery = HKStatisticsCollectionQueryDescriptor(predicate: stepsThisWeek, options: .cumulativeSum, anchorDate: endDate, intervalComponents: everyDay)
        
        let stepsCount = try await sumOfStepsQuery.result(for: healthStore)
        
        stepsCount.enumerateStatistics(from: startDate, to: endDate) { statistics, stop in
            let count = statistics.sumQuantity()?.doubleValue(for: .count())
            let stepsEntry = StepsEntry(stepCount: count ?? 0, date: statistics.startDate)
            
            DispatchQueue.main.async {
                self.stepsEntries.append(stepsEntry)
                _ = self.stepsEntries.sorted(by: { $0.date < $1.date })
            }
        }
    }
}
