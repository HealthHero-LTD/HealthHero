//
//  IdTokenStore.swift
//  HealthHero
//
//  Created by soroush kami on 2024-01-23.
//

import Foundation

struct IdTokenStore: Codable {
    let idToken: String
    
    func encode() -> Data? {
        guard let authData = try? JSONEncoder().encode(self) else {
            return nil
        }
        return authData
    }
}
