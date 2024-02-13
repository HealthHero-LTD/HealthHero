//
//  HttpHeader.swift
//  HealthHero
//
//  Created by Mori Ahmadi on 2024-02-13.
//

import Foundation

enum HttpHeader {
    case authorization(String, String? = nil)
    case contentTypeApplicationJson
    
    var headerKey: String {
        switch self {
        case .authorization:
            return "Authorization"
        case .contentTypeApplicationJson:
            return "Content-Type"
        }
    }
    
    var headerValue: String {
        switch self {
        case .authorization(let token, let nonce):
            if let nonce {
                return "Bearer \(token) \(nonce)"
            } else {
                return "Bearer \(token)"
            }
        case .contentTypeApplicationJson:
            return "application/json"
        }
    }
}
