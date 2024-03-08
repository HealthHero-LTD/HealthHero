//
//  LaunchScreen.swift
//  HealthHero
//
//  Created by soroush kami on 2024-01-30.
//

import SwiftUI
import GoogleSignIn
import JWTDecode

struct LaunchScreen: View {
    @State private var isAccessTokenValid = false
    @State private var isSignInRequire = false
    @EnvironmentObject var vm: ProfileViewModel
    
    var body: some View {
        Group {
            if isAccessTokenValid && vm.isLoggedIn {
                MainView()
            } else {
                SignInScreen()
//                VStack {
//                    Text("Health Hero ツ")
//                        .font(.title)
//                        .fontWeight(.bold)
//                    Spacer()
//                        .frame(height: 400)
//                }
            }
        }
        .onAppear {
            validateToken()
        }
        .fullScreenCover(isPresented: $isSignInRequire, content: {
            SignInScreen()
        })
    }
    
    func validateToken() {
        guard let accessToken = KeychainManager.shared.getAccessToken() else {
            isAccessTokenValid = false
            isSignInRequire = true
            return
        }
        
        do {
            let decodedAccessToken = try JWTDecode.decode(jwt: accessToken)
            if decodedAccessToken.expired {
                isAccessTokenValid = false
                isSignInRequire = true
            } else {
                isAccessTokenValid = true
                vm.isLoggedIn = true
            }
        } catch {
            print("error\(error.localizedDescription)")
        }
    }
}

#Preview {
    LaunchScreen()
}
