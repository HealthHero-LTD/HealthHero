//
//  HealthHeroApp.swift
//  HealthHero
//
//  Created by soroush kami on 2023-12-18.
//

import SwiftUI
import GoogleSignInSwift
import GoogleSignIn

@main
struct HealthHeroApp: App {
    var body: some Scene {
        WindowGroup {
            LaunchScreen()
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
                .onAppear {
                    GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                        if let user = user {
                            print(user)
                        }
                        // Check if `user` exists; otherwise, do something with `error`
                    }
                }
        }
    }
}
