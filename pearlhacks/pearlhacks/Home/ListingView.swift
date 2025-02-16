//
//  ListingView.swift
//  pearlhacks
//
//  Created by Alexandra Marum on 2/15/25.
//

import SwiftUI

struct ListingView: View {
    @State var vm: ListingViewModel = .init()
    @State var searchText: String = ""
    @State private var isFilterPresented = false
    let profile: Profile

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ForEach($vm.listings, id: \.id) { $listing in
                        ListingCardView(listing: $listing, profile: profile)
                    }
                }
            }
            .onAppear {
                vm.filteredListings = vm.listings
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
                        isFilterPresented.toggle()
                    }) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.title2)
                    }
                }
            }
        }
        .searchable(text: $searchText)
        .sheet(isPresented: $isFilterPresented) {
            FilterSheet(vm: $vm)
        }
    }
}

#Preview {
    ListingView(profile: Profile.example)
}
