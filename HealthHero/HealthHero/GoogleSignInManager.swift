//
//  GoogleSignInManager.swift
//  HealthHero
//
//  Created by soroush kami on 2024-01-29.
//

import Foundation
import GoogleSignIn
import JWTDecode


class GoogleSignInManager {
    static let shared = GoogleSignInManager()
    
    private init() {}
    
    func handleSignInButton(completion: @escaping (Bool) -> Void) {
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first
                                              as? UIWindowScene)?.windows.first?.rootViewController
        else { 
            completion(false)
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { signInResult, error in
            guard error == nil else { 
                completion(false)
                return
            }
            guard let result = signInResult else {
                completion(false)
                return
            }
            // set isLoggedIn to true
            let user = result.user
            let emailAddress = user.profile?.email
            // If sign in succeeded, display the app's main content View.
            
            signInResult?.user.refreshTokensIfNeeded { user, error in
                guard error == nil else {
                    completion(false)
                    return
                }
                guard let user = user else {
                    completion(false)
                    return
                }
                
                let idToken = user.idToken // send token to backend
                print(idToken!)
                if let token = idToken?.tokenString {
                    self.sendGoogleTokenBackend(idToken: token) { success in
                        print("token sent to server")
                        completion(true)
                    }
                }
            }
        }
    }
    
    func sendGoogleTokenBackend (idToken: String, completion: @escaping (Bool) -> Void) {
        let idTokenStore = IdTokenStore(idToken: idToken)
        guard let authData = idTokenStore.encode() else {
            completion(false)
            return
        }
        guard let url = URL(string: "http://192.168.2.11:6969/login") else {
            print("Invalid URL")
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.uploadTask(with: request, from: authData) { data, response, error in
            // response from backend
            if let data {
                if let accessTokenStore = AccessTokenStore.decode(from: data) {
                    let accessToken = accessTokenStore.accessToken
                    KeychainManager.shared.saveAccessTokenToKeychain(token: accessToken)
                    completion(true)
                }
            }
        }
        task.resume()
    }
}
