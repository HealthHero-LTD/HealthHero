//
//  ProfileView.swift
//  HealthHero
//
//  Created by soroush kami on 2023-12-29.
//

import SwiftUI
import GoogleSignInSwift
import GoogleSignIn
import JWTDecode

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
            let requestData: [String: Any] = ["key": "value"]
            let jsonData = try? JSONSerialization.data(withJSONObject: requestData)
            
            guard let url = URL(string: "http://192.168.2.11:6969/index") else {
                return
            }
            
            var request = URLRequest(url: url)
            
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type" )
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                } else if let data = data {
                    let responseString = String(data: data, encoding: .utf8)
                    print("response: \(responseString ?? "")")
                }
            }
            task.resume()
            
            print("Log In tapped!")
        }) {
            Text("Log In")
                .foregroundColor(.blue)
                .frame(
                    maxWidth: .infinity,
                    alignment: .center
                )
        }
        
        GoogleSignInButton(action: handleSignInButton)
    }
    
    func handleSignInButton() {
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first
                                              as? UIWindowScene)?.windows.first?.rootViewController
        else { return }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { signInResult, error in
            guard error == nil else { return }
            guard let result = signInResult else { return }
            
            let user = result.user
            let emailAddress = user.profile?.email
            // If sign in succeeded, display the app's main content View.
            
            signInResult?.user.refreshTokensIfNeeded { user, error in
                guard error == nil else { return }
                guard let user = user else { return }
                
                let idToken = user.idToken // send token to backend
                print(idToken!)
                if let token = idToken?.tokenString {
                    sendGoogleTokenBackend(idToken: token)
                    print("token sent to server")
                }
            }
        }
    }
    
    func sendGoogleTokenBackend (idToken: String) {
        guard let authData = try? JSONEncoder().encode(["idToken": idToken]) else {
            return
        }
        let url = URL(string: "http://192.168.2.11:6969/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.uploadTask(with: request, from: authData) { data, response, error in
            // response from backend
            print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
    }
}

#Preview {
    ProfileView()
}
