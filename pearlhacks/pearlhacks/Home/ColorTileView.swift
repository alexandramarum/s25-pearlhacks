import SwiftUI

/// A Coinbase-style tile showing:
/// - Title (top-left, smaller font)
/// - Large value (center, bigger font)
/// - SF Symbol (bottom-right, medium font)
struct FinancialDataTileView: View {
    let backgroundColor: Color
    let title: String
    let value: String
    let iconName: String
    
    var body: some View {
        ZStack {
            // Tile background
            backgroundColor
        }
        .aspectRatio(1, contentMode: .fit) // Make the tile square
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        
        // 1) Title in top-left
        .overlay(
            HStack {
                Text(title)
                    .font(.title2)                 // Apple preset font
                    .foregroundColor(.black)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)       // Scale down if needed
                Spacer()
            }
            .padding(),
            alignment: .topLeading
        )
        
        // 2) Value in center
        .overlay(
            Text(value)
                .font(.largeTitle)               // Larger preset font
                .fontWeight(.bold)
                .foregroundColor(.black)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .padding(),
            alignment: .center
        )
        
        // 3) Icon in bottom-right
        .overlay(
            Image(systemName: iconName)
                .font(.title2)                   // Medium preset font
                .foregroundColor(.black)
                .padding(),
            alignment: .bottomTrailing
        )
    }
}

struct FinancialDataTileView_Previews: PreviewProvider {
    static var previews: some View {
        FinancialDataTileView(
            backgroundColor: Color.green,    // e.g., Color("loangreen")
            title: "Balance",
            value: "$1,234.56",
            iconName: "dollarsign.circle"
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}

