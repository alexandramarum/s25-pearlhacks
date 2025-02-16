//
//  ListingView.swift
//  pearlhacks
//
//  Created by Alexandra Marum on 2/15/25.
//

import SwiftUI

struct ListingView: View {
    @State var vm: ListingViewModel = ListingViewModel()
    
    var body: some View {
        VStack {
            List {
                ForEach(vm.listings) { listing in
                    VStack {
                        Text(listing.street ?? "No street found")
                        Text(listing.town ?? "No city found")
                        Text(listing.price.description)
                    }
                }
            }
            Button {
                do {
                    try vm.getListings(zip: 27707)
                } catch {
                    print("Not working")
                }
            } label: {
                Text("Fetch listings")
            }
        }
    }
}

#Preview {
    ListingView()
}
