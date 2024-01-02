//
//  StatsView.swift
//  HealthHero
//
//  Created by soroush kami on 2023-12-29.
//

import SwiftUI

struct StatsView: View {
    var body: some View {
        HStack {
            
            VStack{
                Text("User's Level")
                    .font(.title3)
                Text("LVL 1")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            }
            
            VStack{
                Text("Soroush_04")
                    .font(.title2)
            }
        }
        .padding(.top)
        .background(.blue)
//        .frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .top)
        .alignmentInfinity(.top)
    }
}

#Preview {
    StatsView()
}
