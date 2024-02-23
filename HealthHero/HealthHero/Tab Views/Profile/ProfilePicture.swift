//
//  ProfilePicture.swift
//  HealthHero
//
//  Created by soroush kami on 2024-01-06.
//

import SwiftUI

struct ProfilePicture: View {
    
    var image: Image
    var body: some View {
        image
            .resizable()
            .frame(width: 120, height: 120)
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.white, lineWidth: 2)
            }
            .shadow(radius: 6)
    }
}

#Preview {
    ProfilePicture(image: Image("profilePic"))
}
