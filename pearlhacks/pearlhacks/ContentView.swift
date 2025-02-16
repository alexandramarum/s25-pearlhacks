//
//  ContentView.swift
//  pearlhacks
//
//  Created by Alexandra Marum on 2/15/25.
//

import SwiftUI

enum AppState {
    case notonboarded
    case onboarded
}

struct ContentView: View {
    @State var currentState: AppState = .notonboarded
    @State var profile: Profile = Profile.example
    
    var body: some View {
        if currentState == .notonboarded {
            PlaidLoginView(state: $currentState, profile: $profile)
        } else {
            TabView {
                Tab("Profile", systemImage: "person") {
                    ProfileView(profile: profile)
                }
                Tab("Listings", systemImage: "house") {
                    ListingView()
                }
            }
            .onAppear {
                UITabBar.appearance().barTintColor = .white
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    ContentView()
}
