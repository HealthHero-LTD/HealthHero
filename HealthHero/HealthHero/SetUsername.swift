//
//  SetUsername.swift
//  HealthHero
//
//  Created by soroush kami on 2024-01-29.
//

import SwiftUI

struct SetUsername: View {
    @State private var username: String = ""

    var body: some View {
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
    
    func saveUsername() {
        // check the username with backend and db
        print("username saved:", username)
    }
}

#Preview {
    SetUsername()
}
