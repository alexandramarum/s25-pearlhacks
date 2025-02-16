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
        ZStack {
//            Color.gray
//                .opacity(0.1)
//                .ignoresSafeArea()
            VStack {
                ScrollView {
                    ForEach(vm.listings) { listing in
                        ListingCardView(listing: listing)
                            .shadow(radius: 5)
                    }
                }
                Spacer()
                Button {
                    do {
                        try vm.getListings(zip: 27516)
                    } catch {
                        print("Not working")
                    }
                } label: {
                    Text("Fetch listings")
                }
            }
        }
    }
}

#Preview {
    ListingView()
}
