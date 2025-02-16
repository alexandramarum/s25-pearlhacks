//
//  ListingCardView.swift
//  pearlhacks
//
//  Created by Alexandra Marum on 2/15/25.
//

import SwiftUI

struct ListingCardView: View {
    @Binding var listing: Listing

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text("$" + listing.price.description)
                            .font(.largeTitle)
                            .bold()
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(Color.accent)
                            .font(.title2)
                    }
                    Text("\(listing.street ?? "No street"), \(listing.town ?? "No town")")
                    //                Text("$" + listing.mortgage.description + "/mo")
                }
                Spacer()
            }
            .padding()
            Image(listing.image)
                .resizable()
                .scaledToFit()
                .shadow(radius: 5)
            HStack(spacing: 20) {
                Button {
                    listing.isSaved.toggle()
                } label: {
                    Image(systemName: listing.isSaved ? "heart.fill" : "heart")
                        .font(.largeTitle)
                        .frame(width: 100, height: 50)
                        .background(in: RoundedRectangle(cornerRadius: 20.0))
                        .shadow(radius: 5)
                        .foregroundStyle(.red)
                }
                Button {
                    
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.largeTitle)
                        .frame(width: 100, height: 50)
                        .background(in: RoundedRectangle(cornerRadius: 20.0))
                        .shadow(radius: 5)
                        .foregroundStyle(.black)
                }
            }
            .padding()
        }
        .background(Color.white
            .shadow(color: Color.gray.opacity(0.5), radius: 5)
        )
    }
}

#Preview {
    ListingCardView(listing: .constant(Listing.examples[0]))
//    CustomButton(icon: "plus", color: .accent)
}
