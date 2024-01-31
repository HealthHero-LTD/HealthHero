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
                        setUsername()
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
    
    func setUsername() {
        guard !username.isEmpty else {
            // Show an alert or message indicating that the username cannot be empty
            return
        }
        
        // Prepare the request payload
        let requestData = ["username": username]
        guard let requestDataJSON = try? JSONSerialization.data(withJSONObject: requestData) else {
            // Handle JSON serialization error
            return
        }
        
        // Prepare the URL for your backend endpoint
        guard let url = URL(string: "http://192.168.2.11:6969/set-username") else {
            // Handle invalid URL error
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Get JWT token from your storage or wherever it's stored after user login
        if let jwtToken = KeychainManager.shared.getAccessToken() {
            // Include JWT token in the request header
            request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
        }
        
        request.httpBody = requestDataJSON
        
        // Perform the network request
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle response...
        }.resume()
    }
}

#Preview {
    SetUsername()
}
