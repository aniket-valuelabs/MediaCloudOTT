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
    
    @FocusState private var focusedField: Field?
    @Environment(\.modelContext) private var modelContext
    
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
                    VStack(spacing: 35) {
                        TextField("First Name", text: $firstName)
                            .customTextFieldStyle(isFocused:focusedField == .firstName)
                            .focused($focusedField, equals: .firstName)
                            .submitLabel(.next)
                            .onSubmit { focusedField = .lastName }
                        
                        TextField("Last Name", text: $lastName)
                            .customTextFieldStyle(isFocused:focusedField == .lastName)
                            .focused($focusedField, equals: .lastName)
                            .submitLabel(.next)
                            .onSubmit { focusedField = .email }
                        
                        TextField("Email", text: $email)
                            .customTextFieldStyle(isFocused:focusedField == .email)
                            .keyboardType(.emailAddress)
                            .focused($focusedField, equals: .email)
                            .submitLabel(.next)
                            .onSubmit { focusedField = .mobileNumber }
                        
                        TextField("Mobile Number", text: $mobileNumber)
                            .customTextFieldStyle(isFocused: focusedField == .mobileNumber)
                            .keyboardType(.numberPad)
                            .focused($focusedField, equals: .registerButton)
                            .submitLabel(.done)
                        Section {
                            Button("Sign Up") {
                                if validateInputs() {
                                    saveUser()
                                    clearFields()
                                    print("Registration successful!")
                                } else {}
                            }
                            .frame(width: 300, height: 70)
                            .buttonStyle(.borderedProminent)
                            .focused($focusedField, equals: .registerButton)
                        }
                        
                    }.padding(.top)
                }
                Spacer()
                    .onAppear {
                        focusedField = .firstName
                    }
                    .onMoveCommand { direction in
                        handleRemoteNavigation(direction)
                    }
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
    func saveUser() {
        let newUser = User(firstName: firstName, lastName: lastName, dob: dob, email: email, mobileNumber: mobileNumber)
        modelContext.insert(newUser)
        try? modelContext.save()
    }
    func clearFields() {
        firstName = ""
        lastName = ""
        dob = Date()
        email = ""
        mobileNumber = ""
        errorMessage = nil
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

//CustomTextfield Modifier
struct CustomTextFieldStyle: ViewModifier {
    var isFocused : Bool
    func body(content: Content) -> some View {
        content
            .textFieldStyle(DefaultTextFieldStyle())
            .padding()
            .frame(width: 800, height: 60)
            .foregroundColor(isFocused ? .black : .white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white, lineWidth: 2)
            )
    }
}

extension View {
    func customTextFieldStyle(isFocused:Bool) -> some View {
        self.modifier(CustomTextFieldStyle(isFocused:isFocused))
    }
}

