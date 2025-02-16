//
//  ListingCardViewModel.swift
//  pearlhacks
//
//  Created by Alexandra Marum on 2/16/25.
//

import Foundation

class ListingCardViewModel {
    func hasBadge(for listing: Listing, profile: Profile) -> Bool {
        // Convert maxLoanApproval to Double for comparison
        guard let maxLoanApproval = Double(profile.maxLoanApproval.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: "")) else {
            return false
        }
        
        // Compare the house price with the max loan approval
        return Double(listing.mortgage) <= maxLoanApproval
    }
}

