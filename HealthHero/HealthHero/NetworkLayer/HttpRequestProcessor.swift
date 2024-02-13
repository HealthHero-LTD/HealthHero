//
//  HttpRequestProcessor.swift
//  HealthHero
//
//  Created by Mori Ahmadi on 2024-02-13.
//

import Foundation
import OSLog

class HttpRequestProcessor {
    func process<T: Decodable>(_ request: HttpRequest) async throws -> T {
        do {
            let urlRequest = try request.urlRequest
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            if let httpResponse = response as? HTTPURLResponse,
               let error = HttpError(httpResponseStatusCode: httpResponse.statusCode) {
                throw error
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: data)
        } catch let error as DecodingError {
            throw HttpError.decodingError(description: error.localizedDescription)
        } catch let error as EncodingError {
            throw HttpError.encodingError(description: error.localizedDescription)
        } catch let error as NSError {
            throw error.toNetworkError()
        }
    }
}

extension NSError {
    func toNetworkError() -> HttpError {
        if self.domain == NSURLErrorDomain {
            switch self.code {
            case NSURLErrorCancelled:
                return .cancelledTask
            case NSURLErrorNotConnectedToInternet:
                return .deviceOffline
            case NSURLErrorCannotConnectToHost:
                return .unableToConnect
            case NSURLErrorTimedOut:
                return .requestTimeout
            default:
                return .unknown
            }
        } else { return .unknown }
    }
}
