//
//  StatsView.swift
//  HealthHero
//
//  Created by soroush kami on 2023-12-29.
//

import SwiftUI
import Charts

struct StatsView: View {
    @State private var stepCount: Double = .zero
    
    var data: [StepsEntry] = [
        .init(day: "Sudnay", stepCount: 500),
        .init(day: "Monday", stepCount: 1500),
        .init(day: "Tuesday", stepCount: 3000),
        .init(day: "Wednesday", stepCount: 400),
        .init(day: "Thursday", stepCount: 250),
        .init(day: "Friday", stepCount: 500),
        .init(day: "Saturday", stepCount: 1000)
    ]
    
    var body: some View {
        VStack {
            Text("Soroush_04")
                .font(.title2)
                .fontWeight(.heavy)
                .padding()
            circleView
            statsDetailView
            
            Chart(data) { entry in
                BarMark(
                    x: .value("Week Day", entry.day),
                    y: .value("Total Steps", entry.stepCount)
                )
            }
            .padding()
        }
        .onAppear {
        }
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
            Text("total step counts: \(stepCount)")
        }
        .frame(maxWidth: 180)
        .font(.body)
        .padding()
    }
}

struct StepsEntry: Identifiable {
    var day: String
    var stepCount: Double
    var id = UUID()
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
