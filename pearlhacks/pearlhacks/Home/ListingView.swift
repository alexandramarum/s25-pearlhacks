//
//  ListingView.swift
//  pearlhacks
//
//  Created by Alexandra Marum on 2/15/25.
//

import SwiftUI

struct ListingView: View {
    @State var vm: ListingViewModel = .init()

    var body: some View {
        VStack {
            ScrollView {
                ForEach(vm.listings) { listing in
                    ListingCardView(listing: listing)
                }
            }
            Spacer()
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
