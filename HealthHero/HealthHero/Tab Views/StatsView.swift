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
                    let modifiedData = weeklyStepData.map { entry in
                        // xp algorithm
                        var score: Int = 0
                        if entry.stepCount <= 500 {
                                score = Int(entry.stepCount / 35)
                            } else if entry.stepCount <= 2000 {
                                score += 500 / 40
                                score += Int((entry.stepCount - 500) / 30)
                            } else if entry.stepCount <= 6000 {
                                score += (500/40) + (1500/30)
                                score += Int((entry.stepCount - 2000) / 25)
                            } else if entry.stepCount <= 10000 {
                                score += (500/40) + (1500/30) + (4000/25)
                                score += Int((entry.stepCount - 6000) / 30)
                            } else {
                                score += (500/40) + (1500/30) + (4000/25) + (4000/30)
                                score += Int((entry.stepCount - 10000) / 100)
                            }
                        print(entry.stepCount, score)
                        return StepsEntry(day: entry.day, stepCount: entry.stepCount, date: entry.date)
                    }
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

struct StepsEntry: Identifiable {
    var id = UUID()
    var day: String
    var stepCount: Double
    var date: Date
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
