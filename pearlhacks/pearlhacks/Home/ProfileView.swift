import SwiftUI

struct Profile {
    var username: String
    var balance: String
    var creditCardDebt: String
    var mortgageDebt: String
    var studentLoanDebt: String
    var debt: String
    var maxLoanApproval: String
}

extension Profile {
    static let example = Profile(
        username: "Alex",
        balance: "$1,234.56",
        creditCardDebt: "$200.00",
        mortgageDebt: "$300.00",
        studentLoanDebt: "$400.00",
        debt: "$900.00",
        maxLoanApproval: "$5,000.00"
        )
}

struct ProfileView: View {
    let profile: Profile
    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // MARK: - Header (Email + Greeting)
                VStack(alignment: .leading, spacing: 4) {
                    // Lighter gray email text
                    Text("\(profile.username.lowercased())@gmail.com")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                    
                    // Bold greeting
                    Text("Hello, \(profile.username.capitalized)!")
                        .font(.largeTitle)
                        .bold()
                }
                // Force left alignment within full width
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 20)
                .padding(.horizontal)
                
                // MARK: - 2x3 Grid of Financial Tiles
                // 3 columns, so with 6 tiles -> 2 rows
                LazyVGrid(
                    columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ],
                    spacing: 16
                ) {
                    FinancialDataTileView(
                        backgroundColor: Color("loangreen").opacity(0.7),
                        title: "Balance",
                        value: profile.balance,
                        iconName: "dollarsign.circle"
                    )
                    
                    FinancialDataTileView(
                        backgroundColor: Color("loanlightgray"),
                        title: "Credit Card",
                        value: profile.creditCardDebt,
                        iconName: "creditcard.fill"
                    )
                    
                    FinancialDataTileView(
                        backgroundColor: Color("loanblue").opacity(0.7),
                        title: "Mortgage",
                        value: profile.mortgageDebt,
                        iconName: "house.fill"
                    )
                    
                    FinancialDataTileView(
                        backgroundColor: Color("loanorange").opacity(0.7),
                        title: "Student Loan",
                        value: profile.studentLoanDebt,
                        iconName: "graduationcap.fill"
                    )
                    
                    FinancialDataTileView(
                        backgroundColor: Color("loan gray"),
                        title: "Total Debt",
                        value: profile.debt,
                        iconName: "minus.circle.fill"
                    )
                    
                    FinancialDataTileView(
                        backgroundColor: Color("loanyellow").opacity(0.7),
                        title: "Max Loan",
                        value: profile.maxLoanApproval,
                        iconName: "checkmark.seal.fill"
                    )
                }
                .padding(.horizontal)
                
                // MARK: - Analysis Section
                analysisSection
                
                Spacer()
            }
        }
        .navigationBarTitle("Profile", displayMode: .inline)
    }
    
    // MARK: - Analysis Section
    private var analysisSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Title
            Text("Analysis of Max Loan Approved")
                .font(.title2)
                .fontWeight(.semibold)
            
            // Explanation
            Text("Your maximum loan approval is determined by a comprehensive review of your financial profile, including current assets, income, and outstanding debt. This figure reflects a practical borrowing limit designed to help lenders gauge your ability to comfortably repay a loan under standard underwriting guidelines.")
                .font(.body)
                .foregroundColor(.secondary)
            
            // Additional details or disclaimers
            Text("How was this calculated?")
                .font(.headline)
            
            Text("""
            • We factor in your monthly income, existing obligations (credit cards, mortgage, student loans), and an industry-standard debt-to-income ratio.
            • We subtract your total debts from your available assets and consider a buffer for unforeseen expenses.
            • The resulting estimate offers insight into the loan amount you might qualify for, potentially streamlining the preapproval process with banks or other financial institutions.

            Please note that final approvals may vary based on individual lender criteria and your overall credit history.
            """)
            .font(.body)
            .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(UIColor.systemGray6))  // A light gray background
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

// MARK: - Preview
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(profile: Profile.example)
    }
}

