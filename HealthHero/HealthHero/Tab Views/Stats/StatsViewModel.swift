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
        if healthKitManager.isAuthorized() {
            healthKitManager.readWeeklyStepCount { weeklyStepData in
                DispatchQueue.main.async {
                    self.stepsData = weeklyStepData
                    
                    // calculate xp
                    let xpDataArray = weeklyStepData.map {
                        let xp = XPManager.convertStepCountToXP($0.stepCount)
                        self.weeklyXP += xp
                        return XPData(date: $0.date, xp: xp)
                    }.filter {
                        if let lastActiveDate = userStore.currentUser.lastActiveDate {
                            return $0.date > lastActiveDate
                        }
                        else {
                            return false
                        }
                    }
                    
                    let lastActiveDayXP = xpDataArray.last?.xp ?? 0
                    let cumulatedXpUntilNow = xpDataArray.reduce(0) { $0 + $1.xp }
                    var storedLastActiveDayXP: Int = UserDefaultsManager.shared.getLastActiveDayXP()
                    let updatedXP = userStore.currentUser.xp - storedLastActiveDayXP + cumulatedXpUntilNow
                    
                    self.levelManager.updateUserXP(updatedXP)
                    storedLastActiveDayXP = lastActiveDayXP
                    UserDefaultsManager.shared.setLastActiveDayXP(storedLastActiveDayXP)
                    
                    let userData = User(
                        level: self.levelManager.currentLevel,
                        xp: self.levelManager.userXP,
                        lastActiveDate: xpDataArray.last?.date,
                        xpDataArray: xpDataArray
                    )
                    
                    self.updateStatTask(data: userData)
                    
                    if let currentDay = weeklyStepData.last {
                        self.stepsCount = currentDay.stepCount
                    }
                }
            }
        } else {
            healthKitManager.requestHealthKitAuthorization()
        }
    }
    
    private func updateStatTask(data: User) {
        Task {
            guard let accessToken = KeychainManager.shared.getAccessToken() else {
                return
            }
            
            let request = HttpRequest(
                endpoint: .updateStats,
                headers: [.authorization(accessToken), .contentTypeApplicationJson],
                httpMethod: .POST,
                body: data
            )
            let updateResult: UpdateResult = try await HttpRequestProcessor().process(request)
        }
    }
    
    
}
