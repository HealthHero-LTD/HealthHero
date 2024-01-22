//
//  TokenManager.swift
//  HealthHero
//
//  Created by soroush kami on 2024-01-22.
//

import Foundation

class TokenManager {
    static let shared = TokenManager()
    private let accessTokenKey = "AccessTokenKey"
    
    func saveAccessToken(token accessToken: String) {
        UserDefaults.standard.set(accessToken, forKey: accessTokenKey)
    }
    
    func getAccessToken() -> String? {
        return UserDefaults.standard.string(forKey: accessTokenKey)
    }
}
