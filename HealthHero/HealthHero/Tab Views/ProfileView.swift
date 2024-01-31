//
//  ProfileView.swift
//  HealthHero
//
//  Created by soroush kami on 2023-12-29.
//

import SwiftUI
import GoogleSignInSwift
import GoogleSignIn

struct ProfileView: View {
    var body: some View {
        
        NavigationStack {
            
            List {
                Section {
                    profileTop
                }
                .listRowBackground(Color.clear)
                
                Section {
                    profileNavLink(navLinkNames:[
                        "Hero Info",
                        "Badges and Titles",
                        "Friends List",
                        "Stats and Goals"
                    ])
                }
                
                Section {
                    profileNavLink(navLinkNames:[
                        "Appearance",
                        "Privacy and Security",
                        "Notifications and Sound",
                    ])
                }
                
                Section {
                    profileLogButton
                }
            }
        }.padding(.top, 1)
    }
    
    @ViewBuilder
    private var profileTop: some View {
        VStack {
            ProfilePicture(image: Image("profilePic"))
            
            Text("Soroush Kami")
                .font(.title)
            
            Text("@Soroush_04")
        }
        .padding()
        .frame(
            maxWidth: .infinity,
            alignment: .center
        )
    }
    
    @ViewBuilder
    private func profileNavLink(navLinkNames: [String]) -> some View {
        ForEach(navLinkNames, id: \.self) { navLinkName in
            NavigationLink(destination: EmptyView()) {
                Text(navLinkName)
            }
        }
    }
    
    @ViewBuilder
    private var profileLogButton: some View {
        Button(action: {
            GIDSignIn.sharedInstance.signOut()
            print("user Logged out!")
        }) {
            Text("Log Out")
                .foregroundColor(.red)
                .frame(
                    maxWidth: .infinity,
                    alignment: .center
                )
        }
    }
}

#Preview {
    ProfileView()
}
