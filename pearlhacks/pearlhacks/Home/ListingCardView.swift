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
        VStack(alignment: .leading) {
            Image(listing.image)
                .resizable()
                .scaledToFill()
                .frame(width: 375, height: 400)
                .clipShape(RoundedRectangle(cornerRadius: 20.0))
            Text("$\(listing.price.description)")
                .bold()
                .font(.largeTitle)
            Text("$\(listing.mortgage.description)/mo")
                .font(.title2)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    ListingCardView(listing: Listing.example)
}
