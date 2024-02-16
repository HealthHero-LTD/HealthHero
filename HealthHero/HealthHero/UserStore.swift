//
//  UserStore.swift
//  HealthHero
//
//  Created by soroush kami on 2024-02-15.
//

import Foundation

class UserStore: ObservableObject {
    @Published var currentUser: UserInfo?
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
        
        currentUser = try? await httpRequestProcessor.process(request)
    }
}
