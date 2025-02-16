//
//  RealEstateModel.swift
//  pearlhacks
//
//  Created by Alexandra Marum on 2/15/25.
//


import Foundation

// Listing
struct Listing: Codable, Identifiable {
    let id = UUID()
    let image: String
    let street: String?
    let town: String?
    let price: Int
    let mortgage: Int
    let bathsfull: Int
    let bathspartial: Int
    let bathstotal: Int
    let beds: Int
    let rooms: Int
}

extension Listing {
    static var example: Listing = Listing(image: "image1", street: "3905 Wentworth Ave", town: "Old Salem", price: 350000, mortgage: 10000, bathsfull: 2, bathspartial: 1, bathstotal: 3, beds: 3, rooms: 3)
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
//struct PropertyDetails: Codable {
//    let property: [DetailedProperty]
//}
//
//struct DetailedProperty: Codable {
//    let identifier: Identifier?
//    let address: DetailedAddress?
//    let location: Location?
//    let building: Building?
//    let mortgage: Mortgage?
//}
//
//struct Building: Codable {
//    let rooms: Rooms
//}
//
//struct Rooms: Codable {
//    let bathsfull, bathspartial, bathstotal, beds: Int
//    let roomsTotal: Int
//}
//
//struct DetailedAddress: Codable {
//    let country, countrySubd, line1, line2: String?
//    let locality, matchCode, oneLine, postal1: String?
//    let postal2, postal3: String?
//}
//
//struct Location: Codable {
//    let accuracy, latitude, longitude: String?
//    let distance: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case accuracy, latitude, longitude, distance
//    }
//}
//
//struct Mortgage: Codable {
//    let lender: Lender?
//    let amount: Int?
//    let date, deedtype, duedate, interestratetype: String?
//}
//
//struct Lender: Codable {
//    let lastname, companycode: String?
//}
//
