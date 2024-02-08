//
//  StepsEntry.swift
//  HealthHero
//
//  Created by soroush kami on 2024-02-06.
//

import Foundation

struct StepsEntry: Identifiable {
    var id = UUID()
    var day: String
    var stepCount: Double
    var date: Date
}
