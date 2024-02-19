//
//  HttpRequest.swift
//  HealthHero
//
//  Created by Mori Ahmadi on 2024-02-13.
//

import Foundation

struct EmptyBody: Codable {}

struct HttpRequest {
    let endpoint: Endpoint
    let headers: [HttpHeader]
    let requestTimeout: TimeInterval
    let httpMethod: HttpMethod
    let body: Encodable?
    
    init(
        endpoint: Endpoint,
        headers: [HttpHeader],
        requestTimeout: TimeInterval = 60,
        httpMethod: HttpMethod,
        body: Encodable? = nil
    ) {
        self.endpoint = endpoint
        self.headers = headers
        self.requestTimeout = requestTimeout
        self.httpMethod = httpMethod
        self.body = body
    }
    
    var urlRequest: URLRequest {
        get throws {
            let url = endpoint.url
            let queryItems = endpoint.queryItems
            let components = try getURLComponents(url: url, with: queryItems)
            return try getRequest(with: components)
        }
    }
        
    private func getURLComponents(
        url: URL,
        with queryItems: [URLQueryItem]
    ) throws -> URLComponents {
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw HttpError.invalidURL(url: url.absoluteString)
        }
        
        if components.queryItems == nil {
            components.queryItems = queryItems
        } else {
            components.queryItems?.append(contentsOf: queryItems)
        }
        
        return components
    }
    
    private func getRequest(with components: URLComponents) throws -> URLRequest {
        guard let url = components.url else {
            throw HttpError.invalidURL(url: self.endpoint.url.absoluteString)
        }
        
        var request = URLRequest(url: url, timeoutInterval: requestTimeout)
        request.httpMethod = self.httpMethod.rawValue
        
        let headerDictionary: [String: String] =
        headers.reduce(into: [:]) { headerDictionary, header in
            headerDictionary[header.headerKey] = header.headerValue
        }
        
        request.allHTTPHeaderFields = headerDictionary
        
        do {
            request.httpBody = try body?.encode()
        } catch {
            throw HttpError.encodingError(description: error.localizedDescription)
        }
        
        return request
    }
}

extension Encodable {
    func encode() throws -> Data {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .secondsSince1970
        return try encoder.encode(self)
    }
}
