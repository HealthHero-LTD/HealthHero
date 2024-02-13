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
    let httpRequestProcessor = HttpRequestProcessor()
    
    private init() {}
    
    func handleSignInButton(completion: @escaping (Bool) -> Void) {
        guard let rootViewController = (
            UIApplication.shared.connectedScenes.first
            as? UIWindowScene
        )?.windows.first?.rootViewController else {
            completion(false)
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { signInResult, error in
            guard error == nil, let result = signInResult else {
                completion(false)
                return
            }
            
            signInResult?.user.refreshTokensIfNeeded { user, error in
                guard error == nil, let user else {
                    completion(false)
                    return
                }
                
                if let idToken = user.idToken?.tokenString {
                    print("token sent to server")
                    Task {
                        let accessTokenStore = try await self.fetchAccessToken(idToken)
                        self.saveAccessTokenToKeychain(accessTokenStore)
                    }
                }
            }
        }
    }
    
    private func fetchAccessToken(_ idToken: String) async throws -> AccessTokenStore {
        let request = HttpRequest(
            endpoint: .login,
            headers: [.contentTypeApplicationJson],
            httpMethod: .POST,
            body: IdTokenStore(idToken: idToken)
        )
        return try await httpRequestProcessor.process(request)
    }
    
    private func saveAccessTokenToKeychain(_ accessTokenStore: AccessTokenStore) {
        let accessToken = accessTokenStore.accessToken
        let tokenId = accessTokenStore.tokenId
        KeychainManager.shared.saveAccessTokenToKeychain(token: accessToken, tokenID: tokenId)
    }
}
