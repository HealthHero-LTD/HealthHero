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
                        Task { try await setUsername() }
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
    
    func setUsername() async throws {
        guard !username.isEmpty else {
            print("empty error")
            return
        }
        
        guard let accessToken = KeychainManager.shared.getAccessToken() else {
            return
        }
        
        let request = HttpRequest(
            endpoint: .setUsername,
            headers: [.authorization(accessToken), .contentTypeApplicationJson],
            httpMethod: .POST,
            body: Username(username: username)
        )
        
        let username: Username = try await HttpRequestProcessor().process(request)
        UserDefaultsManager.shared.setUsername(username.username)
        isUsernameSaved = true
    }
}

#Preview {
    SetUsername()
}
