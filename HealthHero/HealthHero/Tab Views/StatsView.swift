//
//  StatsView.swift
//  HealthHero
//
//  Created by soroush kami on 2023-12-29.
//

import SwiftUI
import Charts

struct StatsView: View {
    @StateObject private var HealthKitManager = HKManager()
    @StateObject private var levelManager: LevelManager
    @EnvironmentObject private var userStore: UserStore
    @State private var stepsCount: Double = .zero
    @State private var stepsData: [StepsEntry] = []
    @State var weeklyXP: Int = .zero
    
    init(currentLevel: Int, userXP: Int) {
        self._levelManager = StateObject(
            wrappedValue: .init(
                currentLevel: currentLevel,
                userXP: userXP
            )
        )
    }
    
    var body: some View {
        VStack {
            Text("@\(userStore.currentUser.username)")
                .font(.title2)
                .fontWeight(.heavy)
                .padding()
            circleView
            statsDetailView
            
            Chart(stepsData) { entry in
                BarMark(
                    x: .value("Week Day", entry.day),
                    y: .value("Total Steps", entry.stepCount)
                )
            }
            .padding()
        }
        .onAppear {
            if HealthKitManager.isAuthorized() {
                HealthKitManager.readWeeklyStepCount { weeklyStepData in
                    self.stepsData = weeklyStepData
                    
                    // calculate xp
                    weeklyXP = .zero
                    let xpDataArray = weeklyStepData.map {
                        let xp = XPManager.convertStepCountToXP($0.stepCount)
                        weeklyXP += xp
                        return XPData(date: $0.date, xp: xp)
                    }.filter {
                        if let lastActiveDate = userStore.currentUser.lastActiveDate {
                            return $0.date > lastActiveDate
                        } 
                        else {
                            return false
                        }
                    }
                    
                    let lastActiveDayXP = xpDataArray.last!.xp
                    let cumulatedXpUntilNow = xpDataArray.reduce(0) { $0 + $1.xp }
                    var storedLastActiveDayXP: Int = UserDefaultsManager.shared.getLastActiveDayXP()
                    let updatedXP = userStore.currentUser.xp - storedLastActiveDayXP + cumulatedXpUntilNow
                    
                    levelManager.updateUserXP(updatedXP)
                    storedLastActiveDayXP = lastActiveDayXP
                    UserDefaultsManager.shared.setLastActiveDayXP(storedLastActiveDayXP)
                    
                    // TODO: pass updatedXp to backend (done)
                    let userData = User(
                        level: levelManager.currentLevel,
                        xp: levelManager.userXP,
                        lastActiveDate: xpDataArray.last?.date,
                        xpDataArray: xpDataArray
                    )
                    
                    updateStatTask(data: userData)
                    
                    if let currentDay = weeklyStepData.last {
                        self.stepsCount = currentDay.stepCount
                    }
                }
            } else {
                HealthKitManager.requestHealthKitAuthorization()
            }
        }
        .animation(.default, value: stepsCount)
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
    
    @ViewBuilder
    private var circleView: some View {
        ZStack {
            Circle()
                .trim(from: 0.0, to: CGFloat(levelManager.levelProgression))
                .stroke(Color.blue, lineWidth: 8)
                .rotationEffect(Angle(degrees: 90))
                .frame(width: 200, height: 200) // frame always comes before anything else
                .padding()
            
            VStack {
                Text("Level \(userStore.currentUser.level)")
                    .font(.title)
                    .foregroundColor(.blue)
                Text("Title: unlockable")
                    .fontWeight(.semibold)
            }
            .padding()
        }
    }
    
    @ViewBuilder
    private var statsDetailView: some View {
        VStack(alignment: .leading) {
            ForEach(StatsDetail.items) { item in
                // TODO: - Use grid here
                HStack {
                    Text(item.title)
                    Spacer()
                    Text(item.value.description)
                }
            }
            
            HStack {
                Text("Current user XP:")
                Spacer()
                Text(String(userStore.currentUser.xp))
            }
        }
        .frame(maxWidth: 180)
        .font(.body)
        .padding()
    }
}

struct StatsDetail: Identifiable {
    var id: String { title }
    
    let title: String
    let value: Double
    
    static let items: [Self] = [
        .init(title: "Current Streak:", value: 5),
        .init(title: "Highest Streak:", value: 10.5),
        .init(title: "Top Placements:", value: 2),
    ]
}
