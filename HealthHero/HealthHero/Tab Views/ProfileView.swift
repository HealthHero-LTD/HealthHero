//
//  ProfileView.swift
//  HealthHero
//
//  Created by soroush kami on 2023-12-29.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        
        VStack {
            Text("Soroush Kami")
                .font(.title)
            Text("@Soroush_04")
        }
        .frame(width: 400, height: 200)
        .background(.green)
        .padding()
        
        Spacer()
        
        VStack {
            
        }
    }
}

#Preview {
    ProfileView()
}
