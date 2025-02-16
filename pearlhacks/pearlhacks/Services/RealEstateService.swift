//
//  Untitled.swift
//  pearlhacks
//
//  Created by Alexandra Marum on 2/15/25.
//
import SwiftUI

@Observable
class RealEstateService {
    let key = Secrets.realEstateKey

    public func fetchPropertiesByAddress(zip: Int) async throws -> [Property] {
        guard let url = URL(string: "https://api.gateway.attomdata.com/propertyapi/v1.0.0/property/address?postalcode=\(zip)") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(key, forHTTPHeaderField: "apikey")

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            let decoded = try JSONDecoder().decode(AllProperties.self, from: data)
            return decoded.property
        } catch {
            print("Request failed: \(error.localizedDescription)")
            throw error
        }
    }

//    private func fetchPropertyDetails(propertyId: Int) async throws -> [DetailedProperty] {
//        guard let url = URL(string: "https://api.gateway.attomdata.com/propertyapi/v1.0.0/property/detailmortgage?attomid=\(propertyId)") else {
//            throw URLError(.badURL)
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.setValue("application/json", forHTTPHeaderField: "Accept")
//        request.setValue(key, forHTTPHeaderField: "apikey")
//
//        do {
//            let (data, _) = try await URLSession.shared.data(for: request)
//            
//            print("property detail data: ")
//            
//            if let jsonString = String(data: data, encoding: .utf8) {
//                        print("Raw JSON: \(jsonString)")
//                    }
//
//            let decoded = try JSONDecoder().decode(PropertyDetails.self, from: data)
//            return decoded.property
//
//        } catch {
//            print("Request failed: \(error.localizedDescription)")
//            throw error
//        }
//    }
}
