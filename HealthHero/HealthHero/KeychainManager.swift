//
//  KeychainManager.swift
//  HealthHero
//
//  Created by soroush kami on 2024-01-25.
//

import Foundation

let serviceName = "com.HealthHero.HealthHeroApp"
let accessTokenKey = "hhAccessToken"

class KeychainManager {
    static let shared = KeychainManager()
    private init() {}
    
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

    func getAccessTokenFromKeychain() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: accessTokenKey,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess, let tokenData = item as? Data else {
            print("Error retrieving access token from Keychain")
            return nil
            
        }
        
        if let accessToken = String(data: tokenData, encoding: .utf8) {
            print("ACCESS TOKEN RECEIVED: \(accessToken)")
            return accessToken
        } else {
            print("error getting access token from keychain")
            return nil
        }
    }

    func deleteAccessTokenFromKeychain() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: accessTokenKey
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            print("Error deleting access token from Keychain")
            return
        }
        
        if status == errSecSuccess {
            print("Access token deleted from Keychain")
        } else {
            print("No access token found in Keychain")
        }
    }
}
