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
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
            // Use filteredListings if filtering is on or if searchText is not empty
                    var listings = vm.filterOn ? vm.filteredListings : vm.listings
                    
                    ForEach(listings.indices, id: \.self) { index in
                        ListingCardView(listing: $vm.listings[index]) // Use correct listings array
                    }
                }
            }
            .onAppear {
                // Fetch listings when the view appears
                Task {
//                    do {
//                        try await vm.getListings(zip: 27707)
//                    } catch {
//                        print("Cannot get listings: \(error)")
//                    }
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
    ListingView()
}
