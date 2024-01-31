//
//  KeychainManager.swift
//  HealthHero
//
//  Created by soroush kami on 2024-01-25.
//

import Foundation

let serviceName = "com.HealthHero.HealthHeroApp"
let accessTokenKey = "hhAccessToken"
let expirationTimeKey = "hhExpirationTime"

class KeychainManager {
    static let shared = KeychainManager()
    private init() {}
    
    func saveAccessTokenToKeychain(token: String, expirationTime: TimeInterval) {
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
            
            var expirationTime = expirationTime
            let expirationTimeData = Data(bytes: &expirationTime, count: MemoryLayout<TimeInterval>.size)
            
            let expirationTimeQuery: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: serviceName,
                kSecAttrAccount as String: expirationTimeKey,
                kSecValueData as String: expirationTimeData
            ]
            
            // delete duplication expiration time
            SecItemDelete(expirationTimeQuery as CFDictionary)
            
            let expirationTimeStatus = SecItemAdd(expirationTimeQuery as CFDictionary, nil)
            guard expirationTimeStatus == errSecSuccess else {
                print("error saving expiration time to Keychain")
                return
            }
            print("ACCESS TOKEN AND EXPIRATION SAVED!")
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
    
    func getExpirationTimeFromKeychain() -> TimeInterval? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: expirationTimeKey,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess, let expirationData = item as? Data else {
            print("error retrieving expiration time from Keychain")
            return nil
        }
        
        var expirationTime: TimeInterval = 0
        expirationData.withUnsafeBytes { (ptr: UnsafeRawBufferPointer) in
            guard let baseAddress = ptr.baseAddress else { return }
            expirationTime = baseAddress.load(as: TimeInterval.self)
        }
        
        print("expiration time received: \(expirationTime)")
        return expirationTime
    }
    
    func deleteUserTokenFromKeychain(
        accessTokenKey: String = "hhAccessToken",
        expirationTimeKey: String = "hhExpirationTime"
    ) {
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
        deleteItem(expirationTimeKey)
    }
}
