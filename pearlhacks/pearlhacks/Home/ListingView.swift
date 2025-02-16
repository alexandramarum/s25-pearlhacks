//
//  ListingView.swift
//  pearlhacks
//
//  Created by Alexandra Marum on 2/15/25.
//

import SwiftUI

struct ListingView: View {
    @State var vm: ListingViewModel = .init() // Use @StateObject to create a single instance of ViewModel
    @State var searchText: String = ""
    @State private var isFilterPresented = false
    let profile: Profile
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    var listings = vm.filterOn ? vm.filteredListings : vm.listings
                    
                    ForEach(listings.indices, id: \.self) { index in
                        ListingCardView(listing: $vm.listings[index], profile: profile)
                    }
                }
            }
            .onAppear {
                Task {
                    do {
                        try await vm.getListings(zip: 27516)
                    } catch {
                        print("Cannot get listings: \(error)")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        isFilterPresented.toggle() // Toggle the filter sheet
                    }) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.title2)
                    }
                }
            }
        }
        .searchable(text: $searchText) // Attach the search bar
        .sheet(isPresented: $isFilterPresented) {
            FilterSheet(vm: $vm) // Pass the ViewModel reference to FilterSheet
        }
    }
}

#Preview {
    ListingView(profile: Profile.example)
}
