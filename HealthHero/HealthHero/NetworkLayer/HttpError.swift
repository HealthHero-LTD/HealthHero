//
//  HttpError.swift
//  HealthHero
//
//  Created by Mori Ahmadi on 2024-02-13.
//

import Foundation

enum HttpError: Error {
    case invalidURL(url: String)
    case unauthorized
    case badRequest
    case serverError
    case cancelledTask
    case unableToConnect
    case deviceOffline
    case decodingError(description: String)
    case encodingError(description: String)
    case requestTimeout
    case unknown
    
    init?(httpResponseStatusCode: Int) {
        switch httpResponseStatusCode {
        case 200...299:
            return nil
        case 401:
            self = .unauthorized
        case 400, 402...499:
            self = .badRequest
        case 500...599:
            self = .serverError
        default:
            self = .unknown
        }
    }
    
    var localizedDescription: String {
        switch self {
        case .invalidURL(let url):
            return "URL: \(url) is not valid"
        case .unauthorized:
            return "401: Authorization failed"
        case .badRequest:
            return "Bad network request"
        case .serverError:
            return "Server error"
        case .decodingError(let description):
            return "Decoding data from network failed with \(description)"
        case .encodingError(let description):
            return "Encoding body from network failed with \(description)"
        case .unknown:
            return "Unknown network error"
        case .cancelledTask:
            return "Network task was cancelled"
        case .unableToConnect:
            return "Unable to establish a connection with server"
        case .deviceOffline:
            return "Device is not connected to internet"
        case .requestTimeout:
            return "Request timed out"
        }
    }
}
