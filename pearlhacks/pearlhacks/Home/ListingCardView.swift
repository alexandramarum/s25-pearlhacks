//
//  ListingCardView.swift
//  pearlhacks
//
//  Created by Alexandra Marum on 2/15/25.
//

import SwiftUI

struct ListingCardView: View {
    var body: some View {
        ZStack{
            VStack(spacing: 5) {
                Image(homeImages[0])
                    .resizable()
                    .cornerRadius(30)
                    .padding(20)
                HStack{
                    Text("$"+homePrice)
                        .font(.system(size: 35, weight: .bold, design: .default))
                    
                    Image(systemName: withinRage ? "checkmark.seal.fill": "checkmark.seal")
                        .foregroundColor(Color("AppOrange"))
                }.padding(.trailing, 140)
                
                Text(homeAddress)
                    .font(.system(size: 25, weight: .regular, design: .default))
                    .lineLimit(nil)
                    .frame(width:360)
                    .padding(.trailing, 5)
                Link("View More", destination: homeURL)
                //.foregroundColor(Color("AppOrange"))
                    .font(.system(size: 15, weight: .bold))
                    .padding(.trailing, 250)
                Spacer()
                
                Button{
                    //pass in the current home object
                    addHome()
                }label:{
                    Image(systemName: "plus.diamond")
                        .font(.system(size:50))
                }
                .padding(.top, 50)
                .padding(.bottom, 100)
                Button{
                    isExpanding.toggle()
                }label:{
                    Image(systemName:"list.bullet")
                        .font(.system(size:35))
                }.padding(.trailing, 250)
            }
            
            if isExpanding{
                VStack{
                    NavButtons()
                        .transition(.slide)
                }
                
            }
        }
    }
}

#Preview {
    ListingCardView()
}
