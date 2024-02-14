//
//  Endpoint.swift
//  HealthHero
//
//  Created by Mori Ahmadi on 2024-02-13.
//

import Foundation

struct Endpoint {
    #if DEBUG
    static let host = "192.168.2.11:6969"
    #else
    static let host = "api.healthhero.app"
    #endif
    
    #if DEBUG
    static let scheme = "http"
    #else
    static let scheme = "https"
    #endif
    
    var path: String
    var queryItems: [URLQueryItem] = []
}

extension Endpoint {
    var url: URL {
        var components = URLComponents()
        components.scheme = Endpoint.scheme
        components.host = Endpoint.host
        components.path = "/" + path
        components.queryItems = queryItems
        
        guard let url = components.url else {
            preconditionFailure(
                "Invalid URL components: \(components)"
            )
        }
        
        return url
    }
}

// MARK: - List of all available endpoints
extension Endpoint {
    static var leaderboard: Self {
        Endpoint(path: "leaderboard")
    }
    
    static var login: Self {
        Endpoint(path: "login")
    }
}
