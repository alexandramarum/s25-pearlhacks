//
//  ListingCardView.swift
//  pearlhacks
//
//  Created by Alexandra Marum on 2/15/25.
//

import SwiftUI

struct ListingCardView: View {
    var listing: Listing

    var body: some View {
        VStack {
            Image(listing.image)
                .resizable()
                .scaledToFit()
            VStack(alignment: .leading) {
                HStack {
                    Text("$" + listing.price.description)
                        .font(.title)
                        .bold()
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(Color.accent)
                        .font(.title2)
                }
                Text("\(listing.street ?? "No street"), \(listing.town ?? "No town")")
                    .font(.title3)
            }
        }
        .background(.secondary.opacity(0.15), in: RoundedRectangle(cornerRadius: 20.0))
    }
}

#Preview {
    ListingCardView(listing: Listing.example)
}
