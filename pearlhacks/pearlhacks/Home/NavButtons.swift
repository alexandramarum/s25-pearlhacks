//
//  NavButtons.swift
//  pearlhacks
//
//  Created by Yahan Yang on 2/15/25.
//

import SwiftUI

struct NavButtons: View {
    //var navButtonImage: String
    
    var body: some View {
        NavigationStack{
            NavigationLink(){
                SavedListingView()
            } label: {
                Image(systemName: "pencil")
                    .font(.system(size: 60))
            }
            NavigationLink(){
                
            } label: {
                Image(systemName: "plus")
                    .font(.system(size:60))
            }
        }
    }
}

#Preview {
    NavButtons()
}
