//
//  ListingViewModel.swift
//  pearlhacks
//
//  Created by Alexandra Marum on 2/15/25.
//

import Foundation

@Observable
class ListingViewModel {
    var listings: [Listing] = []
    let images: [String] = ["image1", "image2", "image3", "image4", "image5", "image6", "image7", "image8", "image9", "image10"]
    
    func getListings(zip: Int) throws {
        var properties: [Property] = []
        Task {
            properties = try await RealEstateService().fetchPropertiesByAddress(zip: zip)
            for property in properties {
                let randomListing = generateRandomListing()
                let newListing = Listing(
                    image: randomListing.image,
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

    // Mortgage calculation based on listing price (simplified formula)
    func calculateMortgage(price: Int) -> Int {
        // Mortgage is calculated with a fixed rate, e.g., 3% annual rate, for a 30-year loan
        let interestRate = 0.03
        let loanTermInYears = 30
        let principal = Double(price)
        let monthlyInterestRate = interestRate / 12
        let numberOfPayments = loanTermInYears * 12

        let mortgage = principal * monthlyInterestRate / (1 - pow(1 + monthlyInterestRate, -Double(numberOfPayments)))
        return Int(mortgage * 12) // Yearly mortgage payment
    }
}
