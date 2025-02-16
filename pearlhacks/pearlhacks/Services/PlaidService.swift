//
//  PlaidService.swift
//  pearlhacks
//
//  Created by Alexandra Marum on 2/15/25.
//

import SwiftUI
import LinkKit

struct PlaidLoginView: View {
    // MARK: - State Variables
    @State private var username: String = ""
    @State private var password: String = ""
    
    // User login token from your backend
    @State private var userToken: String? = nil
    
    // Token from Plaid after successful bank connection
    @State private var plaidAccessToken: String? = nil
    
    // Plaid Link token for opening the Plaid UI
    @State private var linkToken: String? = nil
    
    // Financial Data
    @State private var balance: String = "N/A"
    @State private var income: String = "N/A"
    @State private var creditCardDebt: String = "N/A"
    @State private var mortgageDebt: String = "N/A"
    @State private var studentLoanDebt: String = "N/A"
    @State private var debt: String = "N/A"
    @State private var spending: String = "N/A"
    @State private var maxLoanApproval: String = "Calculating..."
    
    @State private var handler: Handler? = nil
    
    // Controls whether to show the Register sheet
    @State private var showRegisterSheet = false

    // MARK: - Body
    var body: some View {
        VStack {
            if userToken == nil {
                // Show Login Screen
                Text("Login to Your Account")
                    .font(.largeTitle)
                    .padding()
                
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .autocapitalization(.none)
                
                Button(action: loginUser) {
                    Text("Login")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.bottom, 8)
                
                // Register button to open the RegisterView sheet
                Button(action: {
                    showRegisterSheet.toggle()
                }) {
                    Text("Register")
                        .foregroundColor(.blue)
                }
                .sheet(isPresented: $showRegisterSheet) {
                    RegisterView()
                }
            } else if linkToken == nil {
                // User is logged in but Plaid link token isn't fetched yet.
                ProgressView("Fetching Plaid Link Token...")
                    .onAppear {
                        if let token = userToken {
                            fetchLinkToken(userToken: token)
                        }
                    }
            } else if plaidAccessToken == nil {
                // User is logged in and link token exists, but bank hasn't been connected yet.
                Button(action: openPlaidLink) {
                    Text("Connect Your Bank")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(8)
                }
            } else {
                // Bank connected and we have plaidAccessToken—display financial data.
                ProfileView(profile: Profile(
                    username: username,
                    balance: balance,
                    creditCardDebt: creditCardDebt,
                    mortgageDebt: mortgageDebt,
                    studentLoanDebt: studentLoanDebt,
                    debt: debt,
                    maxLoanApproval: maxLoanApproval
                )
                             )
                .onAppear {
                    fetchAllFinancialData()
                }
            }
        }
        .padding()
    }

    // MARK: - Helpers

    func getSecret(_ key: String) -> String? {
        if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) as? [String: Any] {
            return dict[key] as? String
        }
        return nil
    }

    // MARK: - Plaid Flow Functions

    /// Step 1: Login User via your backend.
    func loginUser() {
        guard !username.isEmpty, !password.isEmpty else { return }
        
        let loginURL = URL(string: "http://107.23.249.230:5000/token?username=\(username)&password=\(password)")!
        var request = URLRequest(url: loginURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            if let data = data,
               let response = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let token = response["access_token"] as? String {
                DispatchQueue.main.async {
                    // Save the login token separately
                    self.userToken = token
                    // Now fetch the link token
                    self.fetchLinkToken(userToken: token)
                }
            }
        }.resume()
    }
    
    /// Step 2: Fetch Plaid Link Token using the userToken.
    func fetchLinkToken(userToken: String) {
        let url = URL(string: "http://107.23.249.230:5000/create_link_token?token=\(userToken)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            if let data = data,
               let response = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let token = response["link_token"] as? String {
                DispatchQueue.main.async {
                    self.linkToken = token
                }
            }
        }.resume()
    }
    
    /// Step 3: Open Plaid Link UI.
    func openPlaidLink() {
        guard let linkToken = linkToken else { return }
        
        let linkConfiguration = LinkTokenConfiguration(token: linkToken) { success in
            print("✅ Public Token: \(success.publicToken)")
            exchangePublicToken(publicToken: success.publicToken)
        }
        
        let result = Plaid.create(linkConfiguration)
        switch result {
        case .failure(let error):
            print("❌ Plaid failed to initialize: \(error)")
        case .success(let handler):
            self.handler = handler
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootViewController = scene.windows.first?.rootViewController {
                handler.open(presentUsing: .viewController(rootViewController))
            }
        }
    }
    
    /// Step 4: Exchange Plaid public token for the Plaid access token.
    func exchangePublicToken(publicToken: String) {
        guard let url = URL(string: "http://107.23.249.230:5000/exchange_public_token?public_token=\(publicToken)&username=\(username)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            if let data = data,
               let response = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let plaidToken = response["access_token"] as? String {
                DispatchQueue.main.async {
                    self.plaidAccessToken = plaidToken
                }
            }
        }.resume()
    }
    
    // MARK: - Financial Data Fetching

    /// Step 5: Fetch all financial data from Plaid.
    func fetchAllFinancialData() {
        fetchBalance()
        fetchLiabilities()
    }

    /// Fetch account balance.
    func fetchBalance() {
        guard let plaidAccessToken = plaidAccessToken else { return }
        let url = URL(string: "https://sandbox.plaid.com/accounts/balance/get")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "client_id": getSecret("PLAID_CLIENT_ID") ?? "",
            "secret": getSecret("PLAID_SECRET") ?? "",
            "access_token": plaidAccessToken
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            if let data = data,
               let response = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let accounts = response["accounts"] as? [[String: Any]] {
                
                DispatchQueue.main.async {
                    let totalBalance = accounts.compactMap { $0["balances"] as? [String: Any] }
                                              .compactMap { $0["available"] as? Double }
                                              .reduce(0, +)
                    self.balance = "$\(String(format: "%.2f", totalBalance))"
                    self.calculateMaxLoan()
                }
            }
        }.resume()
    }
    
    
    /// Fetch liabilities (debt).
    func fetchLiabilities() {
        guard let plaidAccessToken = plaidAccessToken else { return }
        let url = URL(string: "https://sandbox.plaid.com/liabilities/get")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "client_id": getSecret("PLAID_CLIENT_ID") ?? "",
            "secret": getSecret("PLAID_SECRET") ?? "",
            "access_token": plaidAccessToken
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            if let data = data,
               let response = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let liabilities = response["liabilities"] as? [String: Any] {
                
                DispatchQueue.main.async {
                    let totalCreditCardDebt = (liabilities["credit"] as? [[String: Any]])?.reduce(0) { $0 + ($1["last_statement_balance"] as? Double ?? 0) } ?? 0
                    let totalMortgageDebt = (liabilities["mortgage"] as? [[String: Any]])?.reduce(0) { $0 + ($1["next_monthly_payment"] as? Double ?? 0) } ?? 0
                    let totalStudentLoanDebt = (liabilities["student"] as? [[String: Any]])?.reduce(0) { $0 + ($1["outstanding_interest_amount"] as? Double ?? 0) } ?? 0
                    
                    self.creditCardDebt = "$\(String(format: "%.2f", totalCreditCardDebt))"
                    self.mortgageDebt = "$\(String(format: "%.2f", totalMortgageDebt))"
                    self.studentLoanDebt = "$\(String(format: "%.2f", totalStudentLoanDebt))"
                    
                    let totalDebt = totalCreditCardDebt + totalMortgageDebt + totalStudentLoanDebt
                    self.debt = "$\(String(format: "%.2f", totalDebt))"
                    self.calculateMaxLoan()
                }
            }
        }.resume()
    }
    
    // MARK: - Loan Calculation
    
    /// Calculate the maximum loan approval amount.
    /// For this example, we use:
    ///   maxLoan = (income * 4) + balance - total debt
    func calculateMaxLoan() {
        let balanceAmount = Double(balance.replacingOccurrences(of: "$", with: "")) ?? 0
        let incomeAmount = Double(income.replacingOccurrences(of: "$", with: "")) ?? 0
        let debtAmount = Double(debt.replacingOccurrences(of: "$", with: "")) ?? 0
        
        let maxLoan = (incomeAmount * 4) + balanceAmount - debtAmount
        
        DispatchQueue.main.async {
            self.maxLoanApproval = "$\(String(format: "%.2f", maxLoan))"
        }
    }
}

#Preview {
    PlaidLoginView()
}


