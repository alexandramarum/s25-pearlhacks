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
        ZStack {
            Color.gray
                .ignoresSafeArea()
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
                    Button {} label: {
                        Image(systemName: "heart")
                            .font(.largeTitle)
                            .frame(width: 100, height: 50)
                            .background(in: RoundedRectangle(cornerRadius: 20.0))
                            .shadow(radius: 5)
                            .foregroundStyle(.red)
                    }
                    Button {} label: {
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
            .background(in: RoundedRectangle(cornerRadius: 20.0))
        }
    }
}

#Preview {
    ListingCardView(listing: Listing.example)
//    CustomButton(icon: "plus", color: .accent)
}
