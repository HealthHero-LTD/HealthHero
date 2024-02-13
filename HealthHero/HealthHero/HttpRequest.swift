//
//  HttpRequest.swift
//  HealthHero
//
//  Created by Mori Ahmadi on 2024-02-13.
//

import Foundation

struct EmptyBody: Codable {}

struct HttpRequest {
    let url: String
    let headers: [HttpHeader]
    let queryItems: [String: String]?
    let requestTimeout: TimeInterval
    let httpMethod: HttpMethod
    let body: Encodable?
    
    init(
        url: String,
        headers: [HttpHeader],
        queryItems: [String: String]? = [:],
        requestTimeout: TimeInterval = 60,
        httpMethod: HttpMethod,
        body: Encodable? = EmptyBody()
    ) {
        self.url = url
        self.headers = headers
        self.queryItems = queryItems
        self.requestTimeout = requestTimeout
        self.httpMethod = httpMethod
        self.body = body
    }
    
    var urlRequest: URLRequest {
        get throws {
            guard let url = URL(string: self.url) else {
                throw HttpError.invalidURL(url: self.url)
            }
            
            let queryItems = getQueryItems(self.queryItems ?? [:])
            let components = try getURLComponents(url: url, with: queryItems)
            return try getRequest(with: components)
        }
    }
    
    private func getQueryItems(_ items: [String: String]) -> [URLQueryItem] {
        guard !items.isEmpty else { return [] }
        
        return items.compactMap { (key: String, value: String) in
            URLQueryItem(name: key, value: value)
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
            throw HttpError.invalidURL(url: self.url)
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
        return try encoder.encode(self)
    }
}
