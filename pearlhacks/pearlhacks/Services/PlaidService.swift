//  PlaidLoginView.swift
//  pearlhacks
//
//  Created by Alexandra Marum on 2/15/25.
//

import SwiftUI
import LinkKit

struct PlaidLoginView: View {
    // MARK: - Bindings
    @Binding var state: AppState
    @Binding var profile: Profile

    // MARK: - Local State Variables
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
                
                Image("NestLetter")
                    .shadow(radius: 3)
                Image("Nest")
                    .resizable()
                    .scaledToFit()
                    .shadow(radius: 2)
                Text("Login")
                    .font(.title2)
                    .foregroundColor(Color.accentColor).opacity(0.8)
                    //.padding()
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
                        .padding(.horizontal, 32)
                        .padding(.vertical, 10)
                        .background(Color.accentColor)
                        .cornerRadius(8)
                }
                .padding(.bottom, 8)
                // Register button to open the RegisterView sheet
                Button(action: {
                    showRegisterSheet.toggle()
                }) {
                    Text("Register")
                        .foregroundColor(.accentColor)
                }
                .sheet(isPresented: $showRegisterSheet) {
                    RegisterView()
                }
                .padding()
                
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
                VStack {
                    Image(.nest)
                        .resizable()
                        .scaledToFit()
                    Button(action: openPlaidLink) {
                        Text("Connect Your Bank")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.accentColor)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            } else {
                // Bank connected and we have plaidAccessToken—display financial data.
                ProgressView("Fetching your financial data...")
                    .onAppear {
                        fetchAllFinancialData()
                        // Delay setting onboarded state to allow fetches to complete
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            state = .onboarded
                        }
                    }
            }
        }
        .padding()
    }
    
    // MARK: - Helper: Update the bound profile with local state values
    func updateProfileBinding() {
        self.profile = Profile(
            username: username,
            balance: balance,
            creditCardDebt: creditCardDebt,
            mortgageDebt: mortgageDebt,
            studentLoanDebt: studentLoanDebt,
            debt: debt,
            maxLoanApproval: maxLoanApproval
        )
    }
    
    // MARK: - Helper Functions

    func getSecret(_ key: String) -> String? {
        if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) as? [String: Any] {
            return dict[key] as? String
        }
        return nil
    }

    /// Step 1: Login User via your backend.
    func loginUser() {
        guard !username.isEmpty, !password.isEmpty else {
            print("Username or password is empty")
            return
        }
        
        let loginURL = URL(string: "http://107.23.249.230:5000/token?username=\(username)&password=\(password)")!
        var request = URLRequest(url: loginURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        print("Attempting login with \(username) / \(password)")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Login error: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Login HTTP Status Code:", httpResponse.statusCode)
            }
            
            guard let data = data else {
                print("No data returned on login")
                return
            }
            
            // Print raw data
            if let dataString = String(data: data, encoding: .utf8) {
                print("Login response data: \(dataString)")
            }
            
            // Try to parse JSON
            if let response = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let token = response["access_token"] as? String {
                
                print("Login success, got token:", token)
                DispatchQueue.main.async {
                    self.userToken = token
                    // Now fetch the link token
                    self.fetchLinkToken(userToken: token)
                }
            } else {
                print("Failed to parse JSON or no access_token in response")
            }
        }.resume()
    }
    
    /// Step 2: Fetch Plaid Link Token using the userToken.
    func fetchLinkToken(userToken: String) {
        let url = URL(string: "http://107.23.249.230:5000/create_link_token?token=\(userToken)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        print("Fetching link token...")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching link token: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Fetch link token HTTP Status Code:", httpResponse.statusCode)
            }
            
            guard let data = data else {
                print("No data returned when fetching link token")
                return
            }
            
            // Print raw data
            if let dataString = String(data: data, encoding: .utf8) {
                print("Link token response data: \(dataString)")
            }
            
            // Try to parse JSON
            if let response = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let token = response["link_token"] as? String {
                
                print("Got link token:", token)
                DispatchQueue.main.async {
                    self.linkToken = token
                }
            } else {
                print("Failed to parse link token response or no link_token found")
            }
        }.resume()
    }
    
    /// Step 3: Open Plaid Link UI.
    func openPlaidLink() {
        guard let linkToken = linkToken else {
            print("No link token available, cannot open Plaid Link")
            return
        }
        
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
        guard let url = URL(string: "http://107.23.249.230:5000/exchange_public_token?public_token=\(publicToken)&username=\(username)") else {
            print("Failed to build exchange_public_token URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        print("Exchanging public token for access token...")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error exchanging public token: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Exchange token HTTP Status Code:", httpResponse.statusCode)
            }
            
            guard let data = data else {
                print("No data returned while exchanging public token")
                return
            }
            
            // Print raw data
            if let dataString = String(data: data, encoding: .utf8) {
                print("Exchange token response data: \(dataString)")
            }
            
            if let response = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let plaidToken = response["access_token"] as? String {
                
                print("Got Plaid access token:", plaidToken)
                DispatchQueue.main.async {
                    self.plaidAccessToken = plaidToken
                }
            } else {
                print("Failed to parse JSON or no access_token found")
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
            guard let data = data else {
                print("No data returned from fetchBalance")
                return
            }
            if let accountsResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let accounts = accountsResponse["accounts"] as? [[String: Any]] {
                DispatchQueue.main.async {
                    let totalBalance = accounts.compactMap { $0["balances"] as? [String: Any] }
                        .compactMap { $0["available"] as? Double }
                        .reduce(0, +)
                    self.balance = "$\(String(format: "%.2f", totalBalance))"
                    self.calculateMaxLoan()
                    self.updateProfileBinding()
                }
            } else {
                print("Failed to parse fetchBalance response")
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
            guard let data = data else {
                print("No data returned from fetchLiabilities")
                return
            }
            if let response = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let liabilities = response["liabilities"] as? [String: Any] {
                DispatchQueue.main.async {
                    let totalCreditCardDebt = (liabilities["credit"] as? [[String: Any]])?.reduce(0) {
                        $0 + ($1["last_statement_balance"] as? Double ?? 0)
                    } ?? 0
                    let totalMortgageDebt = (liabilities["mortgage"] as? [[String: Any]])?.reduce(0) {
                        $0 + ($1["next_monthly_payment"] as? Double ?? 0)
                    } ?? 0
                    let totalStudentLoanDebt = (liabilities["student"] as? [[String: Any]])?.reduce(0) {
                        $0 + ($1["outstanding_interest_amount"] as? Double ?? 0)
                    } ?? 0
                    
                    self.creditCardDebt = "$\(String(format: "%.2f", totalCreditCardDebt))"
                    self.mortgageDebt = "$\(String(format: "%.2f", totalMortgageDebt))"
                    self.studentLoanDebt = "$\(String(format: "%.2f", totalStudentLoanDebt))"
                    
                    let totalDebt = totalCreditCardDebt + totalMortgageDebt + totalStudentLoanDebt
                    self.debt = "$\(String(format: "%.2f", totalDebt))"
                    self.calculateMaxLoan()
                    self.updateProfileBinding()
                }
            } else {
                print("Failed to parse fetchLiabilities response")
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
            self.updateProfileBinding()
        }
    }
}

#Preview {
    PlaidLoginView(state: .constant(.notonboarded), profile: .constant(Profile.example))
}
