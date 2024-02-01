//
//  KeychainManager.swift
//  HealthHero
//
//  Created by soroush kami on 2024-01-25.
//

import Foundation

let serviceName = "com.HealthHero.HealthHeroApp"
let accessTokenKey = "hhAccessToken"
let tokenIDKey = "hhTokenID"

class KeychainManager {
    static let shared = KeychainManager()
    private init() {}
    
    func saveAccessTokenToKeychain(token: String, tokenID: String) {
        // remember this convert data to string
        if let data = token.data(using: .utf8) {
            let tokenQuery: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: serviceName,
                kSecAttrAccount as String: accessTokenKey,
                kSecValueData as String: data
            ]
            // detele duplicate token
            SecItemDelete(tokenQuery as CFDictionary)
            // set new token
            let tokenStatus = SecItemAdd(tokenQuery as CFDictionary, nil)
            guard tokenStatus == errSecSuccess else {
                print("Error saving access token to Keychain")
                return
            }
            
            if let data = tokenID.data(using: .utf8) {
                let tokenQuery: [String: Any] = [
                    kSecClass as String: kSecClassGenericPassword,
                    kSecAttrService as String: serviceName,
                    kSecAttrAccount as String: tokenIDKey,
                    kSecValueData as String: data
                ]
                // detele duplicate token
                SecItemDelete(tokenQuery as CFDictionary)
                // set new token
                let tokenStatus = SecItemAdd(tokenQuery as CFDictionary, nil)
                guard tokenStatus == errSecSuccess else {
                    print("Error saving access token to Keychain")
                    return
                }
                print("ACCESS TOKEN AND TOKEN ID SAVED!")
            }
        }
    }
    
    func getAccessToken() -> String? {
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
    
    func getTokenID() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: tokenIDKey,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess, let tokenData = item as? Data else {
            print("Error retrieving token ID from Keychain")
            return nil
        }
        
        if let tokenID = String(data: tokenData, encoding: .utf8) {
            print("TOKEN ID RECEIVED: \(tokenID)")
            return tokenID
        } else {
            print("error getting token ID from keychain")
            return nil
        }
    }
        
    func deleteUserToken(
        accessTokenKey: String = "hhAccessToken")
     {
        let deleteItem = { (key: String) in
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: serviceName,
                kSecAttrAccount as String: key
            ]
            
            let status = SecItemDelete(query as CFDictionary)
            guard status == errSecSuccess || status == errSecItemNotFound else {
                print("error deleting token from Keychain")
                return
            }
            
            if status == errSecSuccess {
                print("\(key) deleted from Keychain")
            } else {
                print("no \(key) found in Keychain")
            }
        }
        deleteItem(accessTokenKey)
    }
}
