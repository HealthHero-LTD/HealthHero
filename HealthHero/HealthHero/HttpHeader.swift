//
//  HttpHeader.swift
//  HealthHero
//
//  Created by Mori Ahmadi on 2024-02-13.
//

import Foundation

enum HttpHeader {
    case authorization(String)
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
        case .authorization(let token):
            return "Bearer \(token)"
        case .contentTypeApplicationJson:
            return "application/json"
        }
    }
}
