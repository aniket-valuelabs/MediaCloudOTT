//
//  LoginView.swift
//  OTTPoc
//
//  Created by Aniket Kumar on 07/04/25.
//

import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var showValidationError: Bool = false
    @State private var isLoggedIn: Bool = false
    @FocusState private var focusedField: Field?
    
    enum Field {
        case username
        case password
        case loginButton
    }
    
    var body: some View {
            VStack(spacing: 40) {
                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                VStack(spacing: 30) {
                    TextField("Username", text: $username)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .focused($focusedField, equals: .username)
                        .submitLabel(.next)
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .focused($focusedField, equals: .password)
                        .submitLabel(.done)
                }
                
                if showValidationError {
                    Text("Username and Password are required.")
                        .foregroundColor(.red)
                }
                
                Button("Login") {
                    validateAndLogin()
                }
                .disabled(username.isEmpty || password.isEmpty)
                .buttonStyle(.borderedProminent)
                .focused($focusedField, equals: .loginButton)
                
                Spacer()
            }
            .padding()
            .onAppear {
                focusedField = .username
            }
            .onMoveCommand { direction in
                switch direction {
                case .down:
                    switch focusedField {
                    case .username:
                        focusedField = .password
                    case .password:
                        focusedField = .loginButton
                    default:
                        break
                    }
                case .up:
                    switch focusedField {
                    case .loginButton:
                        focusedField = .password
                    case .password:
                        focusedField = .username
                    default:
                        break
                    }
                default:
                    break
                }
            }
            .background(
                LinearGradient(
                    colors: [Color.blue, Color.purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
        }
    
    private func validateAndLogin() {
        if username.isEmpty || password.isEmpty {
            showValidationError = true
        } else {
            showValidationError = false
            isLoggedIn = true
            // Add your login logic here
        }
    }
}



#Preview {
    LoginView()
}
