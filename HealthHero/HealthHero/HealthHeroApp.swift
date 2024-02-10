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
    @Environment(\.scenePhase) var scenePhase
    
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
                .onChange(of: scenePhase) { newPhase in
                    if newPhase == .active {
                        if let lastActiveDate = UserDefaults.standard.object(forKey: "LastActiveDate") as? Date {
                            print(lastActiveDate)
                        } else {
                            print("LastActiveDate not found in UserDefaults")
                        }

                        print("Active")
                    } else if newPhase == .inactive {
                        print("Inactive")
                    } else if newPhase == .background {
                        print("Background")
                        let lastActiveDate = Date()

                        print(lastActiveDate)
                        UserDefaults.standard.set(lastActiveDate, forKey: "LastActiveDate")
                    }
                }
        }
    }
}
