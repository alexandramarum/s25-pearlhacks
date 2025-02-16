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
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ForEach(vm.listings) { listing in
                        ListingCardView(listing: listing)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        // Add filter action here
                    }) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.title2)
                    }
                }
            }
        }
        .searchable(text: $searchText)
        .onAppear {
            do {
                try vm.getListings(zip: 27707)
            } catch {
                print("Cannot get listings: \(error)")
            }
        }
    }
}

#Preview {
    ListingView()
}
