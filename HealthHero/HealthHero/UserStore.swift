//
//  UserStore.swift
//  HealthHero
//
//  Created by soroush kami on 2024-02-15.
//

import Foundation

class UserStore: ObservableObject {
    @Published var currentUser: UserInfo = UserInfo()
    let httpRequestProcessor = HttpRequestProcessor()
    
    @MainActor
    func fetchCurrentUser() async {
        guard let accessToken = KeychainManager.shared.getAccessToken() else {
            return
        }
        
        let request = HttpRequest(
            endpoint: .getUser,
            headers: [.authorization(accessToken)],
            httpMethod: .GET
        )
        
        do {
            currentUser = try await httpRequestProcessor.process(request)
        } catch let httpError as HealthHero.HttpError {
            print("HTTP Error: \(httpError.localizedDescription)")
        } catch {
            print("Unexpected Error: \(error.localizedDescription)")
        }
    }
}
