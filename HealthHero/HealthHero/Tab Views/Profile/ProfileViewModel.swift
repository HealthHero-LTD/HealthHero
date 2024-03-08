//
//  ProfileViewModel.swift
//  HealthHero
//
//  Created by soroush kami on 2024-03-05.
//

import SwiftUI

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
}

