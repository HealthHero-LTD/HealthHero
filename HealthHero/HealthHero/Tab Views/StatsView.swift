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
            
            Spacer()
        }
        //        .alignmentInfinity(.top)
    }
}


#Preview {
    StatsView()
}

//struct ToyShape: Identifiable {
//    var type: String
//    var count: Double
//    var id = UUID()
//}
