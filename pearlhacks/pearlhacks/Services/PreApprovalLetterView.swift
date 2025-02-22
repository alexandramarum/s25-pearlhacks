//
//  PreApprovalLetterView.swift
//  pearlhacks
//
//  Created by Yahan Yang on 2/16/25.
//

import SwiftUI

struct PreApprovalLetterView: View {
    var listing: Listing
    var loan: Int = 55
    
    var body: some View {
        // ScrollView {
        VStack(alignment: .leading, spacing: 10) {
            // Title
            Text("NEST")
                .foregroundColor(Color("AppGreen"))
                .bold()
                .font(.title3) +
                Text(" MORTGAGE PRE-APPROVAL LETTER")
                .bold()
                .font(.title3)
                   
            // Date
            Text("Date: ")
                .bold() +
            Text(Date.now.addingTimeInterval(600), style:.date)
                .foregroundColor(Color("AppGreen"))
                   
            // Sender Information
            VStack(alignment: .leading, spacing: 2) {
                Text("From: ")
                    .bold() +
                    Text("NEST Mortgage Approval Service")
                    .foregroundColor(Color("AppGreen"))
                       
                Text("Address: 145 E. Cameron Street")
                Text("City, State: Chapel Hill, NC")
                Text("Zip: 27514")
            }
                   
            // Subject
            Text("NOTICE OF PRE-APPROVAL")
                .bold()
                   
//            // Recipient Greeting
//            Text("Dear ")
//                .bold() +
//                Text("John Henry,")
//                .foregroundColor(.red)
//                .bold()
//                   
            // Body Text
            Text("""
            Based on the information furnished by you, we are pleased to inform \
            you of pre-approval for a residential home mortgage loan with the following parameters:
            """)
                   
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text("Property Address: ")
                        .bold()
                    Text("\(listing.street ?? "unknown"), \(listing.town ?? "unknown") \(listing.zipcode)")
                        .foregroundColor(Color("AppGreen"))
                }
                HStack {
                    Text("Sales Price: ")
                        .bold()
                    Text("$\(listing.price)")
                        .foregroundColor(Color("AppGreen"))
                }
                HStack {
                    Text("Loan Amount: ")
                        .bold()
                    Text("$\(loan)")
                        .foregroundColor(Color("AppGreen"))
                }
                HStack {
                    Text("Term of Loan: ")
                        .bold()
                    Text("30-year, conventional")
                        .foregroundColor(Color("AppGreen"))
                }
            }
                   
            // Conditions
            Text("In order to obtain final approval of the loan, the following conditions must be met:")
                   
            VStack(alignment: .leading, spacing: 2) {
                CheckBoxText(text: "Satisfactory Purchase Agreement")
                CheckBoxText(text: "Sufficient Appraisal for the Property")
                CheckBoxText(text: "Marketable Title to the Property")
            }
                   
            // Disclaimer
            Text("""
            Please note that your loan will need to be officially underwritten and given official \
            approval before funding of the property to take place. This is not a commitment to lend \
            and you are not required to obtain a loan simple because you have received this letter.
            """)
                   
            // Signature
            Text("Sincerely,")
                .padding(.top)
                   
            Text("Bob Frank")
                .foregroundColor(Color("AppGreen"))
                .bold()
                .underline()
                   
            Text("Bob Frank, Loan Officer")
            Text("NEST Mortgage Approval Service")
                .foregroundColor(Color("AppGreen"))
                   
            Spacer()
        }
        .padding()
    }
}

// }

// Reusable component for a checkbox with text
struct CheckBoxText: View {
    let text: String
    var body: some View {
        HStack {
            Image(systemName: "checkmark.square.fill")
                .foregroundColor(Color("AppGreen"))
            Text(text)
        }
    }
}

#Preview {
    PreApprovalLetterView(listing: Listing.examples[0])
}
