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
    @State private var showValidationError: Bool = false
    @FocusState private var focusedField: Field?
    @State private var navigateToHome = false
    @State private var navigateToRegister = false

    enum Field: Hashable {
        case username, password, loginButton, registerButton
    }

    var body: some View {
        NavigationStack {
            
            VStack(spacing: 50) {
                Text("Welcome to MediaStreaming App")
                    .font(.system(size: 45, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                VStack(spacing: 35) {
                    TextField("Username", text: $username)
                        .textContentType(.username)
                        .padding()
                        .frame(width: 800, height: 60)
                        .cornerRadius(12)
                        .foregroundColor(.white)
                        .focused($focusedField, equals: .username)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .password
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white, lineWidth: 2)
                        )
                    
                    SecureField("Password", text: $password)
                        .textContentType(.password)
                        .padding()
                        .frame(width: 800, height: 60)
                        .cornerRadius(12)
                        .foregroundColor(.white)
                        .focused($focusedField, equals: .password)
                        .submitLabel(.done)
                        .onSubmit {
                            focusedField = .loginButton
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white, lineWidth: 2)
                        )
                }
                
                if showValidationError {
                    Text("Please enter both username and password.")
                        .foregroundColor(.red)
                        .font(.title2)
                }
                
                HStack(spacing: 20) {
                    Button("Login") {
                        handleLogin()
                    }
                    .frame(width: 300, height: 70)
                    .buttonStyle(.borderedProminent)
                    .focused($focusedField, equals: .loginButton)
                    
                    Button("Register") {
                        navigateToRegister = true
                    }
                    .frame(width: 300, height: 70)
                    .buttonStyle(.bordered)
                    .focused($focusedField, equals: .registerButton)
                }
                
                Spacer()
            }
            .padding(.top, 100)
            .onAppear {
                focusedField = .username
            }
//            .onMoveCommand(perform: handleRemoteNavigation)
            .background(Color.clear)
            
            .navigationDestination(isPresented: $navigateToHome) {
                Dashboard()
                //Feedback()
            }
            .navigationDestination(isPresented: $navigateToRegister) {
                SignUpView()
            }
           
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
       .edgesIgnoringSafeArea(.all)
    }

    private func handleLogin() {
//        if username.isEmpty || password.isEmpty {
//            showValidationError = true
//        } else {
//            showValidationError = false
//            navigateToHome = true
//        }
        navigateToHome = true
    }

    private func handleRemoteNavigation(_ direction: MoveCommandDirection) {
        guard let current = focusedField else { return }

        switch direction {
        case .down:
            if current == .username {
                focusedField = .password
            } else if current == .password {
                focusedField = .loginButton
            } else if current == .loginButton {
                focusedField = .registerButton
            }
        case .up:
            if current == .registerButton {
                focusedField = .loginButton
            } else if current == .loginButton {
                focusedField = .password
            } else if current == .password {
                focusedField = .username
            }
        default:
            break
        }
    }
}
