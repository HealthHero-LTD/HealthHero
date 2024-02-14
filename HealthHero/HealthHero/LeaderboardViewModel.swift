//
//  LeaderboardViewModel.swift
//  HealthHero
//
//  Created by soroush kami on 2024-01-28.
//

import Foundation

@MainActor
class LeaderboardViewModel: ObservableObject {
    @Published var leaderboardEntries: [LeaderboardEntry] = []
    let httpRequestProcessor = HttpRequestProcessor()
    
    private let cacheKey = "LeaderboarCache"
    
    init () {
        loadCachedData()
    }
    
    func fetchLeaderboardData() async throws {
        let request = HttpRequest(
            endpoint: .leaderboard,
            headers: [.contentTypeApplicationJson],
            httpMethod: .GET
        )
        self.leaderboardEntries = try await httpRequestProcessor.process(request)
        self.saveCachedData()
    }
    
    func refreshLeaderboardData() async throws {
        try await fetchLeaderboardData()
    }
    
    func loadCachedData() {
        if let data = UserDefaults.standard.data(forKey: cacheKey) {
            do {
                self.leaderboardEntries = try JSONDecoder().decode([LeaderboardEntry].self, from: data)
                print("cached data loaded")
            } catch {
                print("error with loading cache data \(error.localizedDescription)")
            }
        }
    }
    
    func saveCachedData() {
        do {
            let data = try JSONEncoder().encode(leaderboardEntries)
            UserDefaults.standard.set(data, forKey: cacheKey)
            print("cached data saved successfully")
        } catch {
            print("error with saving cached data \(error.localizedDescription)")
        }
    }
}
