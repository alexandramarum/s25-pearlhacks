//
//  LoadingView.swift
//  pearlhacks
//
//  Created by Upasana Lamsal on 2/16/25.
//

import SwiftUI

struct LoadingView: View {
    @State private var progress: CGFloat = 0.0
    @State private var isActive = false
    
    var body: some View {
        if isActive {
            PlaidLoginView(state: .constant(.onboarded), profile: .constant(Profile.example))
        } else {
            ZStack {
                // 1) Custom green background from Assets.xcassets
                Color("loangreen")
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // 2) Logo in the center
                    Image("houseUpLogo")  // Replace with your actual image name
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height:300)
                    
                    // 3) Progress bar
                    ProgressView(value: Double(progress), total: 1.0)
                        .progressViewStyle(LinearProgressViewStyle())
                        .tint(.white) // Make the progress bar white
                        .scaleEffect(x: 1, y: 2, anchor: .center) // Thicker bar
                        .padding(.horizontal, 40)
                        .animation(.easeInOut(duration: 10), value: progress)
                }
            }
            // 4) Animate the progress bar over 3 seconds, then navigate
            .onAppear {
                progress = 0
                              
                              // Next runloop, set progress to 1 -> triggers the 4s animation
                              DispatchQueue.main.async {
                                  progress = 1
                              }
                              
                              // After 4s, transition to PlaidLoginView
                              DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                                  isActive = true
                              }
            }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
