//
//  ListingCardView.swift
//  pearlhacks
//
//  Created by Alexandra Marum on 2/15/25.
//

import SwiftUI

struct ListingCardView: View {
    @Binding var listing: Listing
    @State var showDetails: Bool = false

    var body: some View {
        NavigationStack {
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
                    showDetails.toggle()
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.largeTitle)
                        .frame(width: 100, height: 50)
                        .background(in: RoundedRectangle(cornerRadius: 20.0))
                        .shadow(radius: 5)
                        .foregroundStyle(Color.accentColor)
                }
            }
            .padding()
            if showDetails {
                showDetailsView(listing: listing)
            }
        }
        .background(Color.white
            .shadow(color: Color.gray.opacity(0.5), radius: 5)
        )
    }
}

struct showDetailsView: View {
    var listing: Listing
    
    var body: some View {
        NavigationLink(destination: PDFService_(listing: listing)) {
            Text("Generate PDF")
                .font(.headline)
                .foregroundStyle(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(.bottom)
        .padding(.horizontal)
    }
}

#Preview {
    ListingCardView(listing: .constant(Listing.examples[1]))
//    CustomButton(icon: "plus", color: .accent)
}
