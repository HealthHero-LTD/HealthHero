//
//  StatsViewModel.swift
//  HealthHero
//
//  Created by soroush kami on 2024-02-15.
//

import SwiftUI

@MainActor
class StatsViewModel: ObservableObject {
    private var healthKitManager = HKManager()
    @Published var levelManager: LevelManager
    @Published var stepsCount: Double = .zero
    @Published var stepsData: [StepsEntry] = []
    @Published var weeklyXP: Int = .zero
    
    init(userStore: UserStore) {
        self.levelManager = LevelManager(
            currentLevel: userStore.currentUser.level,
            userXP: userStore.currentUser.xp
        )
        Task {
            await healthKitManager.requestHealthKitAuthorization()
            let calendar = Calendar.current
            let today = Date()
            let oneWeekAgo = calendar.date(byAdding: .day, value: -7, to: today)!
            try await healthKitManager.calculateSteps(
                from: oneWeekAgo
            )
            
            stepsData = healthKitManager.stepsEntries
            
            let xpData = populateXPData(
                healthKitManager.stepsEntries,
                userStore.currentUser.lastActiveDate
            )
            
            updateLevel(with: xpData, currentXP: userStore.currentUser.xp)
            
            updateStatTask(data: xpData)
            
            if let currentDay = healthKitManager.stepsEntries.last {
                stepsCount = currentDay.stepCount
            }
        }
    }
    
    private func updateStatTask(data: [XPData]) {
        let userData = User(
            level: self.levelManager.currentLevel,
            xp: self.levelManager.userXP,
            lastActiveDate: data.last?.date,
            xpDataArray: data
        )
        
        Task {
            guard let accessToken = KeychainManager.shared.getAccessToken() else {
                return
            }
            
            let request = HttpRequest(
                endpoint: .updateStats,
                headers: [.authorization(accessToken), .contentTypeApplicationJson],
                httpMethod: .POST,
                body: userData
            )
            let updateResult: UpdateResult = try await HttpRequestProcessor().process(request)
        }
    }
    
    private func populateXPData(_ stepEntries: [StepsEntry], _ lastActiveDate: Date?) -> [XPData] {
        stepEntries.map {
            let xp = XPManager.convertStepCountToXP($0.stepCount)
            self.weeklyXP += xp
            return XPData(date: $0.date, xp: xp)
        }.filter {
            if let lastActiveDate {
                return $0.date >= lastActiveDate
            } else {
                return false
            }
        }
    }
    
    private func updateLevel(with xpData: [XPData], currentXP: Int) {
        let lastActiveDayXP = xpData.last?.xp ?? 0
        let cumulatedXpUntilNow = xpData.reduce(0) { $0 + $1.xp }
        var storedLastActiveDayXP: Int = UserDefaultsManager.shared.getLastActiveDayXP()
        let updatedXP = currentXP - storedLastActiveDayXP + cumulatedXpUntilNow
        
        self.levelManager.updateUserXP(updatedXP)
        storedLastActiveDayXP = lastActiveDayXP
        UserDefaultsManager.shared.setLastActiveDayXP(storedLastActiveDayXP)
    }
}
