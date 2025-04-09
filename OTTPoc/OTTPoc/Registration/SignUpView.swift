//
//  SignUpView.swift
//  VL_OTT
//
//  Created by Janakiraman Kanagaraj on 07/04/25.
//

import SwiftUI

struct SignUpView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var dob: Date = Date()
    @State private var email = ""
    @State private var mobileNumber = ""
    
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    TextField("First Name", text: $firstName)
                        .textFieldStyle(DefaultTextFieldStyle())
                    
                    TextField("Last Name", text: $lastName)
                        .textFieldStyle(DefaultTextFieldStyle())
                                        
                    TextField("Email", text: $email)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .keyboardType(.emailAddress)
                    
                    TextField("Mobile Number", text: $mobileNumber)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .keyboardType(.numberPad)
                }
                
                Section {
                    Button(action: {
                        if validateInputs() {
                            // Proceed with registration logic here
                            print("Registration successful!")
                        } else {
                            // Display error message
                        }
                    }) {
                        Text("Register")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            .navigationTitle("Registration")
            .alert(isPresented: Binding<Bool>.constant(errorMessage != nil)) {
                Alert(title: Text("Error"), message: Text(errorMessage ?? ""), dismissButton: .default(Text("OK")))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.5), Color.green.opacity(0.5)]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
            )
            .edgesIgnoringSafeArea(.all)
        }
    }
    
    func validateInputs() -> Bool {
        guard !firstName.isEmpty, !lastName.isEmpty, !email.isEmpty, !mobileNumber.isEmpty else {
            errorMessage = "All fields are required."
            return false
        }
        
        guard let _ = Int(mobileNumber) else {
            errorMessage = "Invalid mobile number."
            return false
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if dateFormatter.string(from: dob).isEmpty {
            errorMessage = "Invalid date of birth."
            return false
        }
        
        // Validate email format
        let emailRegex = #"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#
        if !NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email) {
            errorMessage = "Invalid email address."
            return false
        }
        
        return true
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
