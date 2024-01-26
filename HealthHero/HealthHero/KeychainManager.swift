//
//  KeychainManager.swift
//  HealthHero
//
//  Created by soroush kami on 2024-01-25.
//

import Foundation
import Security

let serviceName = "com.HealthHero.HealthHeroApp"
let accessTokenKey = "hhAccessToken"

func saveAccessTokenToKeychain(token: String) {
    // remember this convert data to string
    if let data = token.data(using: .utf8) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: accessTokenKey,
            kSecValueData as String: data
        ]
        // detele duplicate token
        SecItemDelete(query as CFDictionary)
        // set new token
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            print("Error saving access token to Keychain")
            return
        }
        print("TOKEN SAVEEED")
    }
}
