//
//  LaunchScreen.swift
//  HealthHero
//
//  Created by soroush kami on 2024-01-30.
//

import SwiftUI
import GoogleSignIn

struct LaunchScreen: View {
    @State private var isAccessTokenValid = false
    @State private var isSignInRequire = false
    
    var body: some View {
        Group {
            if isAccessTokenValid {
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
                    // check google sign in status
                    GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                        if error != nil || user == nil {
                            // show signed out state
                            DispatchQueue.main.async {
                                isSignInRequire = true
                                print("google token is not validate")
                            }
                        } else {
                            // show signed in state
                            DispatchQueue.main.async {
                                isAccessTokenValid = true
                                print("google token is validate")
                            }
                        }
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $isSignInRequire, content: {
            SignInScreen()
        })
    }
    
//    func validateToken() {
//        if let expirationTimeDouble = KeychainManager.shared.getExpirationTime() {
//            let currentUnixTimestamp = Date().timeIntervalSince1970
//            if expirationTimeDouble > currentUnixTimestamp {
//                print("Token is valid")
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                    isAccessTokenValid = true
//                }
//            } else {
//                print("Token has expired")
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                    isSignInRequire = true
//                    // send request for refresh token here!
//                }
//            }
//        } else {
//            print("token not found")
//            isSignInRequire = true
//        }
//    }
}

#Preview {
    LaunchScreen()
}
