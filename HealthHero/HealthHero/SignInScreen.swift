//
//  SignInScreen.swift
//  HealthHero
//
//  Created by soroush kami on 2024-01-29.
//

import SwiftUI
import GoogleSignInSwift

struct SignInScreen: View {
    var body: some View {
        Spacer()
            .frame(height: 500)
        
        GoogleSignInButton(
            action: GoogleSignInManager.shared.handleSignInButton
        )
        .frame(width: 300)
    }
}

#Preview {
    SignInScreen()
}
