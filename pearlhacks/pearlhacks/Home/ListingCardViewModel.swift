//
//  ListingCardViewModel.swift
//  pearlhacks
//
//  Created by Alexandra Marum on 2/16/25.
//

import Foundation

class ListingCardViewModel {
    func hasBadge(for listing: Listing, profile: Profile) -> Listing {
        // Convert maxLoanApproval to Double for comparison
        guard let maxLoanApproval = Double(profile.maxLoanApproval.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: "")) else {
            return listing
        }
        
        // Compare the house price with the max loan approval
        if Double(listing.mortgage) <= maxLoanApproval*4 {
            return Listing(image: listing.image, zipcode: listing.zipcode, street: listing.street, town: listing.town, price: listing.price, mortgage: listing.mortgage, bathsfull: listing.bathsfull, bathspartial: listing.bathspartial, bathstotal: listing.bathstotal, beds: listing.bathsfull, rooms: listing.rooms, hasBadge: true)
        } else {
            return listing
        }
    }
}

