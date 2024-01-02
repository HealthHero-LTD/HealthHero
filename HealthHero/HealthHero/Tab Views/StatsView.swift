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
            
            ZStack {
                Circle()
                    .trim(from: 0.0, to: 0.65)
                    .stroke(Color.blue, lineWidth: 8)
                    .rotationEffect(Angle(degrees: 90))
                    .padding()
                    .frame(width: 240, height: 240)
                
                VStack {
                    Text("Level 1")
                        .font(.title)
                        .foregroundColor(.blue)
                    Text("Title: unlockable")
                        .fontWeight(.semibold)
                }
                .padding()
            }
            
            VStack(alignment: .leading) {
                
                HStack {
                    Text("Completed Tasks:")
                    Text("30")
                }
                
                HStack {
                    Text("Current Streak:")
                    Text("5")
                }
                
                HStack {
                    Text("Highest Streak:")
                    Text("7")
                }
                
                HStack {
                    Text("Top Placements:")
                    Text("2")
                }
                
                Text("total step counts: \(stepCount)")
                
                .onAppear {
                    HKManager.readStepCount { stepCount in
                        self.stepCount = stepCount
                    }
                }
            }
            .font(.body)
            .padding()
            
            Chart {
                ForEach(data) { entry in
                    BarMark(
                        x: .value("Week Day", entry.day),
                        y: .value("Total Steps", entry.stepCount)
                    )
                }
            }
            .padding()
        }
    }
}

#Preview {
    StatsView()
}

struct StepsEntry: Identifiable {
    var day: String
    var stepCount: Double
    var id = UUID()
}
