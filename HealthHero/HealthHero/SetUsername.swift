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
            print("empty error")
            return
        }
        
        let requestData = ["username": username]
        guard let requestDataJSON = try? JSONSerialization.data(withJSONObject: requestData) else {
            print("username json error")
            return
        }
        
        guard let url = URL(string: "http://192.168.2.11:6969/set-username") else {
            print("invalid set username url")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let jwtToken = KeychainManager.shared.getAccessToken() {
            print("its working ?", jwtToken)
            request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
        }
        
        request.httpBody = requestDataJSON
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("set username error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("invalid response for set username")
                return
            }
            
            if httpResponse.statusCode == 200 {
                print("username set successfully")
                isUsernameSaved = true
//                DispatchQueue.main.async {
//                    // Update UI or perform any necessary action
//                }
            } else {
                print("failed to set username: \(httpResponse.statusCode)")
            }
        }.resume()
    }
}

#Preview {
    SetUsername()
}
