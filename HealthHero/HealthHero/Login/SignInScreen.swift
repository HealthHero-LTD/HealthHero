//
//  SignInScreen.swift
//  HealthHero
//
//  Created by soroush kami on 2024-01-29.
//

import SwiftUI
import GoogleSignInSwift

struct SignInScreen: View {
    @State private var isLoggedIn = false
    @State var username = UserDefaultsManager.shared.getUsername()
    
    var body: some View {
        Group {
            if isLoggedIn {
                if username == nil {
                    SetUsername()
                } else {
                    MainView()
                }
            } else {
                Spacer()
                    .frame(height: 500)
                
                GoogleSignInButton(
                    action: {
                        GoogleSignInManager.shared.handleSignInButton { success in
                            if success {
                                isLoggedIn = true
                            } else {
                                print("Login failed")
                            }
                        }
                    }
                )
                .frame(width: 300)
            }
        }
    }
}

#Preview {
    SignInScreen()
}
