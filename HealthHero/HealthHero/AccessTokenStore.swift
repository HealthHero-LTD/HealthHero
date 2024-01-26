//
//  AccessTokenStore.swift
//  HealthHero
//
//  Created by soroush kami on 2024-01-23.
//

import Foundation

struct AccessTokenStore: Codable {
    let accessToken: String
    
    static func decode(from authData: Data) -> AccessTokenStore? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            let token = try decoder.decode(AccessTokenStore.self, from: authData)
            return token
        }
        catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
