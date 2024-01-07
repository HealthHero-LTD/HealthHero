//
//  ProfileView.swift
//  HealthHero
//
//  Created by soroush kami on 2023-12-29.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        
        NavigationView {
            List {
                Section {
                    VStack {
                            ProfilePicture(image: Image("profilePic"))
                            
                            Text("Soroush Kami")
                                .font(.title)
                            
                            Text("@Soroush_04")
                        }
                        .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .listRowBackground(Color.clear)
                

                Section(
//                    header: Text(
//                        "Account"
//                    )
                ) {
                    NavigationLink(destination: EmptyView()) {
                        Text("Hero Info")
                    }
                    
                    NavigationLink(destination: EmptyView()) {
                        Text("Badges and Titles")
                    }
                    
                    NavigationLink(destination: EmptyView()) {
                        Text("Friends List")
                    }
                    
                    NavigationLink(destination: EmptyView()) {
                        Text("Stats and Goals")
                    }
                    
                    
                }
                
                Section {
                    
                    NavigationLink(destination: EmptyView()) {
                        Text("Appearance")
                    }
                    
                    NavigationLink(destination: EmptyView()) {
                        Text("Privacy and Security")
                    }
                    
                    NavigationLink(destination: EmptyView()) {
                        Text("Notifications and Sound")
                    }
                    
                  
                }
                
                Section {
                    Button(action: {
                        // log in to Apple account
                        print("Log In tapped!")
                    }) {
                        Text("Log In")
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            
            }
            .listStyle(InsetGroupedListStyle())
        }.padding(.top, 1)
    }
}

#Preview {
    ProfileView()
}
