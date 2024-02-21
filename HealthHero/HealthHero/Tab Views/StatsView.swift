//
//  StatsView.swift
//  HealthHero
//
//  Created by soroush kami on 2023-12-29.
//

import SwiftUI
import Charts

struct StatsView: View {
    @StateObject private var statsViewModel: StatsViewModel
    var userStore: UserStore
    
    init(userStore: UserStore) {
        self.userStore = userStore
        self._statsViewModel = StateObject(
            wrappedValue:
                    .init(userStore: userStore)
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
            
            Chart(statsViewModel.stepsData) { entry in
                BarMark(
                    x: .value("Week Day", entry.day),
                    y: .value("Total Steps", entry.stepCount)
                )
            }
            .padding()
        }
    }
    
    @ViewBuilder
    private var circleView: some View {
        ZStack {
            Circle()
                .trim(
                    from: 0.0,
                    to: CGFloat(
                        statsViewModel.levelManager.levelProgression
                    )
                )
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
