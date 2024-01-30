//
//  SetUsername.swift
//  HealthHero
//
//  Created by soroush kami on 2024-01-29.
//

import SwiftUI

struct SetUsername: View {
    @State private var username: String = ""
    @State private var isUsernameSaved: Bool = false
    
    var body: some View {
        Group {
            if isUsernameSaved {
                MainView()
            } else {
                VStack {
                    Spacer()
                        .frame(height: 400)
                    
                    TextField("Enter username", text: $username)
                        .frame(width: 300)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                    
                    Button(action: {
                        saveUsername()
                        print(KeychainManager.shared.getExpirationTimeFromKeychain()!)
                        if let expirationTimeDouble = KeychainManager.shared.getExpirationTimeFromKeychain() {
                            let currentUnixTimestamp = Date().timeIntervalSince1970
                            if expirationTimeDouble > currentUnixTimestamp {
                                print("Token is valid")
                            } else {
                                print("Token has expired")
                            }
                        } else {
                            print("Expiration time not found in the keychain.")
                        }
                    }) { Text("Save")
                            .frame(width: 200)
                            .padding()
                            .foregroundColor(.white)
                            .background(.blue)
                            .cornerRadius(8)
                            .contentShape(Rectangle())
                    }
                }
            }
        }
    }
    
    func saveUsername() {
        // check the username with backend and db
        print("username saved:", username)
        isUsernameSaved = true
    }
}

#Preview {
    SetUsername()
}
