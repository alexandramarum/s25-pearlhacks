//
//  RealEstateModel.swift
//  pearlhacks
//
//  Created by Alexandra Marum on 2/15/25.
//

import Foundation

// Listing
struct Listing: Identifiable {
    let id = UUID()
    let image: String
    let zipcode: String
    let street: String?
    let town: String?
    let price: Int
    let mortgage: Int
    let bathsfull: Int
    let bathspartial: Int
    let bathstotal: Int
    let beds: Int
    let rooms: Int
    var isSaved: Bool = false
    var hasBadge: Bool = false
}

extension Listing {
    static var examples: [Listing] = [
        Listing(image: "image1", zipcode: "27707", street: "3905 Wentworth Ave", town: "Wilmington", price: 200000, mortgage: 1000, bathsfull: 2, bathspartial: 1, bathstotal: 3, beds: 3, rooms: 3),
        Listing(image: "image6", zipcode: "27707", street: "5555 Total Rd", town: "Old Salem", price: 350000, mortgage: 1344, bathsfull: 2, bathspartial: 1, bathstotal: 3, beds: 3, rooms: 3),
        Listing(image: "image3", zipcode: "27707", street: "4000 Wentworth Dr", town: "Old Salem", price: 500000, mortgage: 1313, bathsfull: 2, bathspartial: 1, bathstotal: 3, beds: 3, rooms: 3),
        Listing(image: "image4", zipcode: "27707", street: "3905 Wentworth Ave", town: "Old Salem", price: 350000, mortgage: 355, bathsfull: 2, bathspartial: 1, bathstotal: 3, beds: 3, rooms: 3),
        Listing(image: "image5", zipcode: "27707", street: "3905 Wentworth Ave", town: "Old Salem", price: 293000, mortgage: 324, bathsfull: 2, bathspartial: 1, bathstotal: 3, beds: 3, rooms: 3)]
}

// Random Listing
struct RandomListing {
    let image: String
    let price: Int
    let mortgage: Int
    let bathsfull: Int
    let bathspartial: Int
    let bathstotal: Int
    let beds: Int
    let rooms: Int
}

// Fetch properties by zip
struct AllProperties: Codable {
    let property: [Property]
}

struct Property: Codable {
    let identifier: Identifier
    let address: Address
}

struct Address: Codable {
    let country, countrySubd, line1, line2: String?
    let locality, matchCode, oneLine, postal1: String?
    let postal2, postal3: String?
}

struct Identifier: Codable {
    let id: Int?
    let attomID: Int?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case attomID = "attomId"
    }
}

//// Fetch property details
// struct PropertyDetails: Codable {
//    let property: [DetailedProperty]
// }
//
// struct DetailedProperty: Codable {
//    let identifier: Identifier?
//    let address: DetailedAddress?
//    let location: Location?
//    let building: Building?
//    let mortgage: Mortgage?
// }
//
// struct Building: Codable {
//    let rooms: Rooms
// }
//
// struct Rooms: Codable {
//    let bathsfull, bathspartial, bathstotal, beds: Int
//    let roomsTotal: Int
// }
//
// struct DetailedAddress: Codable {
//    let country, countrySubd, line1, line2: String?
//    let locality, matchCode, oneLine, postal1: String?
//    let postal2, postal3: String?
// }
//
// struct Location: Codable {
//    let accuracy, latitude, longitude: String?
//    let distance: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case accuracy, latitude, longitude, distance
//    }
// }
//
// struct Mortgage: Codable {
//    let lender: Lender?
//    let amount: Int?
//    let date, deedtype, duedate, interestratetype: String?
// }
//
// struct Lender: Codable {
//    let lastname, companycode: String?
// }
//
