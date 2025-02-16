//
//  RegisterView.swift
//  pearlhacks
//
//  Created by Upasana Lamsal on 2/16/25.
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var newUsername = ""
    @State private var newPassword = ""
    
    var body: some View {
        VStack {
            Text("Create New Account")
                .font(.largeTitle)
                .padding()
                .foregroundColor(Color.accentColor)
                .bold()
                .shadow(radius: 1.5)
            
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
                    .background(Color.accentColor)
                    .cornerRadius(8)
            }
            
            Spacer()
            Image("Nest")
                .resizable()
                .scaledToFit()
                .shadow(radius: 1)
        }
        .padding()
    }
    
    func registerUser() {
        print("Register button pressed")
        guard !newUsername.isEmpty, !newPassword.isEmpty else {
            print("Username or password is empty")
            return
        }
        
        // Build the register endpoint URL
        guard let registerURL = URL(string: "http://107.23.249.230:5000/register?username=\(newUsername)&password=\(newPassword)") else {
            print("Failed to create URL")
            return
        }
        
        var request = URLRequest(url: registerURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for client-side errors
            if let error = error {
                print("Error during registration: \(error.localizedDescription)")
                return
            }
            
            // Print HTTP status code
            if let httpResponse = response as? HTTPURLResponse {
                print("Registration HTTP Status Code:", httpResponse.statusCode)
            }
            
            // Check for data
            guard let data = data else {
                print("No data received from registration endpoint")
                return
            }
            
            // Print raw response body
            if let dataString = String(data: data, encoding: .utf8) {
                print("Raw registration response: \(dataString)")
            }
            
            // Attempt JSON parse
            if let jsonResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                print("Parsed JSON response: \(jsonResponse)")
            } else {
                print("Failed to parse JSON response")
            }
            
            // If registration was successful, dismiss
            DispatchQueue.main.async {
                presentationMode.wrappedValue.dismiss()
            }
        }.resume()
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
