//
//  RegisterView.swift
//  pearlhacks
//
//  Created by Upasana Lamsal on 2/16/25.
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var newUsername = ""
    @State private var newPassword = ""
    
    var body: some View {
        VStack {
            Text("Create a New Account")
                .font(.largeTitle)
                .padding()
            
            TextField("Username", text: $newUsername)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            SecureField("Password", text: $newPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .autocapitalization(.none)
            
            Button(action: registerUser) {
                Text("Register")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            
            Spacer()
        }
        .padding()
    }
    
    func registerUser() {
        guard !newUsername.isEmpty, !newPassword.isEmpty else { return }
        
        // Build the register endpoint URL
        let registerURL = URL(string: "http://107.23.249.230:5000/register?username=\(newUsername)&password=\(newPassword)")!
        var request = URLRequest(url: registerURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Perform network request
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle errors or parse server response if needed
            guard let data = data,
                  let _ = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
            else {
                // Could show an alert on error
                return
            }

            // If register succeeded, dismiss the sheet
            DispatchQueue.main.async {
                presentationMode.wrappedValue.dismiss()
            }
        }.resume()
    }
}


#Preview {
    RegisterView()
}
