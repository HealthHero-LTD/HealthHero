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
    @State var userLevel: Int = UserDefaultsManager.shared.getUserLevel()
    
    var body: some View {
        VStack {
            Text("Soroush_04")
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
                        LevelManager.shared.updateUserXP(weeklyXP)
                        return XPData(date: $0.date, xp: xp)
                    }.filter {
                        $0.date > UserDefaultsManager.shared.getLastActiveDate()
                    }
                    
                    let firstXPData = xpDataArray.first!
                    let xp = firstXPData.xp
                    print("XP: \(xp)")
                    
                    UserDefaults.standard.setValue(weeklyXP, forKey: "WeeklyXP")
                    
                    let retrievedWeeklyXP = UserDefaults.standard.integer(forKey: "WeeklyXP")
                    UserDefaults.standard.removeObject(forKey: "WeeklyXP")
                    print("get weeklyxp from user defaults: \(retrievedWeeklyXP)")
                    

                    
                    print("user level is \(UserDefaultsManager.shared.getUserLevel())")
                    // send xpDataArray to backend
                    guard let url = URL(string: "http://192.168.2.11:6969/update-xp") else {
                        print("invalid URL for XP transmission")
                        return
                    }
                    
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    
                    if let jwtToken = KeychainManager.shared.getAccessToken() {
                        request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
                    }
                    
                    do {
                        let encoder = JSONEncoder()
                        encoder.dateEncodingStrategy = .secondsSince1970
                        let jsonData = try encoder.encode(xpDataArray)
                        request.httpBody = jsonData
                    } catch {
                        print("error encoding XP data: \(error)")
                        return
                    }
                    
                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
                        if let error = error {
                            print("Error sending XP data: \(error)")
                            return
                        }
                        
                        guard let httpResponse = response as? HTTPURLResponse else {
                            print("invalid response for set username")
                            return
                        }
                        
                        if httpResponse.statusCode == 200 {
                            print("XP updated")
                        }
                    }
                    task.resume()
                    
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
    
    @ViewBuilder
    private var circleView: some View {
        ZStack {
            Circle()
                .trim(from: 0.0, to: 0.65)
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
                Text("Weekly XP:")
                Spacer()
                Text(String(weeklyXP))
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
