//
//  ContentView.swift
//  pearlhacks
//
//  Created by Alexandra Marum on 2/15/25.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            Tab("Profile", systemImage: "person") {
                    Text("Profile")
                }
            Tab("Listings", systemImage: "house") {
                    ListingView()
                }
            Tab("Saved", systemImage: "heart") {
                    SavedListingView()
                }
        }
        .onAppear {
            UITabBar.appearance().barTintColor = .white
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
