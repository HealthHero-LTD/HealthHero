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
    @State private var stepsCount: Double = .zero
    @State private var stepsData: [StepsEntry] = []
    @State var weeklyXP: Int = .zero
    @State var userXP: Int = UserDefaultsManager.shared.getUserXP()
    @State var storedLastActiveDayXP: Int = UserDefaultsManager.shared.getLastActiveDayXP()
    var userLevel: Int { LevelManager.shared.currentLevel }
    @State var username: String = UserDefaultsManager.shared.getUsername()
    
    var body: some View {
        VStack {
            Text("@\(username)")
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
                        $0.date > UserDefaultsManager.shared.getLastActiveDate()
                    }
                    
                    let lastActiveDayXP = xpDataArray.last!.xp
                    let cumulatedXpUntilNow = xpDataArray.reduce(0) { $0 + $1.xp }

                    userXP = userXP - storedLastActiveDayXP + cumulatedXpUntilNow
                    LevelManager.shared.updateUserXP(userXP)
                    storedLastActiveDayXP = lastActiveDayXP
                    UserDefaultsManager.shared.setLastActiveDayXP(storedLastActiveDayXP)
                    UserDefaultsManager.shared.setUserXP(userXP)
                    
                    let userData = User(
                        level: UserDefaultsManager.shared.getUserLevel(),
                        username: UserDefaultsManager.shared.getUsername(),
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
                .trim(from: 0.0, to: CGFloat(LevelManager.shared.levelProgression))
                .stroke(Color.blue, lineWidth: 8)
                .rotationEffect(Angle(degrees: 90))
                .frame(width: 200, height: 200) // frame always comes before anything else
                .padding()
            
            VStack {
                Text("Level \(userLevel)")
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
                Text(String(userXP))
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

#Preview {
    StatsView()
}
