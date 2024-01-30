//
//  LaunchScreen.swift
//  HealthHero
//
//  Created by soroush kami on 2024-01-30.
//

import SwiftUI

struct LaunchScreen: View {
    @State private var isValidate = false
    @State private var isSignInRequire = false
    
    var body: some View {
        Group {
            if isValidate {
                MainView()
            } else {
                VStack {
                    Text("Health Hero ツ")
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                        .frame(height: 400)
                }
                .onAppear() {
                    tokenValidation()
                }
            }
        }
        .fullScreenCover(isPresented: $isSignInRequire, content: {
            SignInScreen()
        })
    }
    
    func tokenValidation() {
        if let expirationTimeDouble = KeychainManager.shared.getExpirationTimeFromKeychain() {
            let currentUnixTimestamp = Date().timeIntervalSince1970
            if expirationTimeDouble > currentUnixTimestamp {
                print("Token is valid")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    isValidate = true
                }
            } else {
                print("Token has expired")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    isSignInRequire = true
                    // send request for refresh token here!
                }
            }
        } else {
            print("token not found")
            isSignInRequire = true
        }
    }
}

#Preview {
    LaunchScreen()
}
