//
//  LeaderboardViewModel.swift
//  HealthHero
//
//  Created by soroush kami on 2024-01-28.
//

import Foundation

class LeaderboardViewModel: ObservableObject {
    @Published var leaderboardEntries: [LeaderboardEntry] = []
    
    private let cacheKey = "LeaderboarCache"
    
    init () {
        loadCachedData()
    }
    
    func fetchLeaderboardData() {
        // we can fetch backend data here(maybe?)
        let url = URL(string: "http://192.168.2.11:6969/leaderboard")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error: \(error!.localizedDescription)")
                return
            }
            print("leaderboard data received")
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("HTTP Error: \(httpResponse.statusCode)")
                return
            } else {
                print("response received")
            }
            
            do {
                let leaderboardData = try JSONDecoder().decode([LeaderboardEntry].self, from: data)
                print("leaderboard data updated successfully")
                DispatchQueue.main.async {
                    self.leaderboardEntries = leaderboardData
                    self.saveCachedData()
                }
            } catch {
                print("JSON Parsing Error: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    func refreshLeaderboardData() {
        fetchLeaderboardData()
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
