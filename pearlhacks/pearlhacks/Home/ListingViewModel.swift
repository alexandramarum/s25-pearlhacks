//
//  ListingViewModel.swift
//  pearlhacks
//
//  Created by Alexandra Marum on 2/15/25.
//

import Foundation
import SwiftUI

struct Filtered: Equatable {
    var min: Int = 0
    var max: Int = 2000000
    var savedListings: Bool = false
    var eligibleListings: Bool = true
}

@Observable
class ListingViewModel {
    var listings: [Listing] = []
    let images: [String] = ["image1", "image3", "image4", "image5", "image6", "image7", "image8", "image9", "image10"]
    var filteredListings: [Listing] = []
    
    var filterSettings: Filtered = .init()
    var filterOn: Bool = false
    
    func getListingBinding(by id: UUID) -> Binding<Listing>? {
        guard let index = listings.firstIndex(where: { $0.id == id }) else {
            return nil
        }
        return Binding(get: { self.listings[index] },
                       set: { self.listings[index] = $0 })
    }
    
    func getListings(zip: Int) throws {
        var properties: [Property] = []
        Task {
            properties = try await RealEstateService().fetchPropertiesByAddress(zip: zip)
            for property in properties {
                let randomListing = generateRandomListing()
                let newListing = Listing(
                    image: randomListing.image,
                    zipcode: property.address.matchCode ?? "Not available",
                    street: property.address.line1,
                    town: property.address.line2,
                    price: randomListing.price,
                    mortgage: randomListing.mortgage,
                    bathsfull: randomListing.bathsfull,
                    bathspartial: randomListing.bathspartial,
                    bathstotal: randomListing.bathstotal,
                    beds: randomListing.beds,
                    rooms: randomListing.rooms
                )
                listings.append(newListing)
            }
        }
    }
    
    func applyFilters() {
        filteredListings = listings
        if filterSettings.eligibleListings && filterSettings.savedListings {
            filteredListings = listings.filter { listing in
                listing.isSaved && listing.hasBadge
            }
        } else if filterSettings.eligibleListings {
            filteredListings = listings.filter { listing in
                listing.hasBadge
            }
        } else if filterSettings.savedListings {
            filteredListings = listings.filter { listing in
                listing.isSaved
            }
        }
//        if filterSettings.eligibleListings { filteredListings = listings.filter { listing in
//            listing.hasBadge
//        }
//        filteredListings = listings.filter { listing in
//            let price = listing.price
//            return price >= filterSettings.min && price <= filterSettings.max
//        }
//        if filterSettings.savedListings {
//            filteredListings = filteredListings.filter { listing in
//                listing.isSaved
//            }
//        }
//        }
    }
        
    func generateRandomListing() -> RandomListing {
        let listingPrice = Int.random(in: 100000..<2000000)
        let mortgage = calculateMortgage(price: listingPrice)
        let beds = Int.random(in: 1..<6)
        let bathsfull = Int.random(in: 1..<4)
        let bathspartial = Int.random(in: 0..<3)
        let bathstotal = bathsfull + bathspartial
        let rooms = beds + Int.random(in: 1..<3)
            
        return RandomListing(image: images.randomElement()!, price: listingPrice, mortgage: mortgage, bathsfull: bathsfull, bathspartial: bathspartial, bathstotal: bathstotal, beds: beds, rooms: rooms)
    }
        
    func calculateMortgage(price: Int) -> Int {
        let interestRate = 0.03
        let loanTermInYears = 30
        let principal = Double(price)
        let monthlyInterestRate = interestRate / 12
        let numberOfPayments = loanTermInYears * 12
            
        let mortgage = principal * monthlyInterestRate / (1 - pow(1 + monthlyInterestRate, -Double(numberOfPayments)))
        return Int(mortgage * 12)
    }
}
