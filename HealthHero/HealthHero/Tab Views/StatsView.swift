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
                    let xpDataArray = weeklyStepData.map { entry in
                        let xp = XPManager.convertStepCountToXP(entry.stepCount)
                        print(Int(entry.stepCount), xp)
                        return XPData(date: entry.date, xp: xp)
                    }
                    
                    // send xpDataArray to backend
                    guard let url = URL(string: "http://192.168.2.11:6969/update-xp") else {
                        print("invalid URL for XP transmission")
                        return
                    }
                    
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    
                    do {
                        let jsonData = try JSONEncoder().encode(xpDataArray)
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
                        
                        if let httpResponse = response as? HTTPURLResponse {
                            print("Response status code: \(httpResponse.statusCode)")
                            // handle response status
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
                Text("Level 1")
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
            Text("total step counts: \(Int(stepsCount))")
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
