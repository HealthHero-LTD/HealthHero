//
//  ProfileView.swift
//  HealthHero
//
//  Created by soroush kami on 2023-12-29.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        
        VStack() {
            VStack {
                ProfilePicture(image: Image("profilePic"))
                
                Text("Soroush Kami")
                    .font(.title)
                
                Text("@Soroush_04")
            }
            .padding()
            
            NavigationView {
                List {
                    NavigationLink(destination: EmptyView()) {
                        Text("Account Info")
                    }
                    
                    NavigationLink(destination: EmptyView()) {
                        Text("Badges and Titles")
                    }
                    
                    NavigationLink(destination: EmptyView()) {
                        Text("Connections")
                    }
                }
            }
            
            NavigationView {
                List {
                    NavigationLink(destination: EmptyView()) {
                        Text("Privacy and Security")
                    }
                    
                    NavigationLink(destination: EmptyView()) {
                        Text("Notifications and Sound")
                    }
                    
                    NavigationLink(destination: EmptyView()) {
                        Text("Appearance")
                    }
                }
            }
            
            VStack {
                List {
                    Button(action: {
                        // log in to apple account
                        print("Log In tapped!")
                    } )
                    {
                        Text("Log In")
                            .foregroundColor(.blue)
                            .frame(
                                maxWidth: .infinity,
                                alignment: .center
                            )
                    }
                }
                .frame(width: 300)
            }
        }
    }
}

#Preview {
    ProfileView()
}
