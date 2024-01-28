//
//  LeaderboardView.swift
//  HealthHero
//
//  Created by soroush kami on 2023-12-29.
//

import SwiftUI

struct LeaderboardView: View {
    @ObservedObject var leaderboardViewModel = LeaderboardViewModel()
    
    var body: some View {
        VStack {
            Text("Leaderboard")
                .font(.title)
                .padding()
            
            List {
                LeaderboardHeader()
                ForEach(leaderboardViewModel.leaderboardEntries) { entry in
                    LeaderboardRow(entry: entry)
                }
            }
            Button("Refresh") {
                leaderboardViewModel.refreshLeaderboardData()
            }
        }
    }
}

struct LeaderboardHeader: View {
    var body: some View {
        HStack {
            Text("#")
                .fontWeight(.bold)
                .frame(width: 25, alignment: .leading)
            Text("Hero")
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
            Text("LVL")
                .fontWeight(.bold)
                .frame(width: 30, alignment: .center)
            Text("Score")
                .fontWeight(.bold)
                .frame(width: 50, alignment: .center)
        }
    }
}


struct LeaderboardRow: View {
    let entry: LeaderboardEntry
    
    var body: some View {
        HStack {
            Text("\(entry.id)")
                .frame(width: 25, alignment: .leading)
            Text(entry.username)
                .frame(maxWidth: .infinity, alignment: .center)
            Text("\(entry.level)")
                .frame(width: 25, alignment: .center)
            Text("\(entry.score)")
                .frame(width: 50, alignment: .center)
        }
    }
}

#Preview {
    LeaderboardView()
}

struct LeaderboardEntry: Identifiable, Codable {
    let id: Int
    let username: String
    let level: Int
    let score: Int
}

class LeaderboardViewModel: ObservableObject {
    @Published var leaderboardEntries: [LeaderboardEntry] = []
    
    func refreshLeaderboardData() {
        fetchLeaderboardData()
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
                }
            } catch {
                print("JSON Parsing Error: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}
