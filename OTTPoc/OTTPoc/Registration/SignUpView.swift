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
    @State private var mobileNumber = "9600474273"
    
    @State private var errorMessage: String?
    
    @FocusState private var focusedField: Field?
    
    enum Field: Hashable {
        case firstName
        case lastName
        case email
        case mobileNumber
        case registerButton
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("Sign Up")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Form {
                    Section(header: Text("Personal Information").foregroundColor(.white)) {
                        TextField("First Name", text: $firstName)
                            .textFieldStyle(DefaultTextFieldStyle())
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .focused($focusedField, equals: .firstName)
                            .submitLabel(.next)
                            .onSubmit { focusedField = .lastName }
                        
                        TextField("Last Name", text: $lastName)
                            .textFieldStyle(DefaultTextFieldStyle())
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .focused($focusedField, equals: .lastName)
                            .submitLabel(.next)
                            .onSubmit { focusedField = .email }
                        
                        TextField("Email", text: $email)
                            .textFieldStyle(DefaultTextFieldStyle())
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .keyboardType(.emailAddress)
                            .focused($focusedField, equals: .email)
                            .submitLabel(.next)
                            .onSubmit { focusedField = .mobileNumber }
                        
                        TextField("Mobile Number", text: $mobileNumber)
                            .textFieldStyle(DefaultTextFieldStyle())
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .keyboardType(.numberPad)
                            .focused($focusedField, equals: .mobileNumber)
                            .submitLabel(.done)
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
                        .focused($focusedField, equals: .registerButton)
                    }
                }
                .padding(.top)
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.top)
                }
                
                Spacer()
            }
            .onAppear {
                focusedField = .firstName
            }
            .onMoveCommand { direction in
                handleRemoteNavigation(direction)
            }
            .background(
                LinearGradient(colors: [Color.green, Color.yellow], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
            )
            .alert(isPresented: Binding<Bool>.constant(errorMessage != nil)) {
                Alert(title: Text("Error"), message: Text(errorMessage ?? ""), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func validateInputs() -> Bool {
        guard !firstName.isEmpty, !lastName.isEmpty, !email.isEmpty, !mobileNumber.isEmpty else {
            errorMessage = "All fields are required."
            return false
        }
        
        guard let _ = Int(mobileNumber) else {
            errorMessage = "Invalid mobile number."
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
    
    private func handleRemoteNavigation(_ direction: MoveCommandDirection) {
        switch direction {
        case .down:
            switch focusedField {
            case .firstName:
                focusedField = .lastName
            case .lastName:
                focusedField = .email
            case .email:
                focusedField = .mobileNumber
            case .mobileNumber:
                focusedField = .registerButton
            default:
                break
            }
        case .up:
            switch focusedField {
            case .registerButton:
                focusedField = .mobileNumber
            case .mobileNumber:
                focusedField = .email
            case .email:
                focusedField = .lastName
            case .lastName:
                focusedField = .firstName
            default:
                break
            }
        default:
            break
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
