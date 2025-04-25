//
//  Feedback.swift
//  OTTPoc
//
//  Created by Aniket Kumar on 16/04/25.
//

import SwiftUI
import UIKit

struct Feedback: View {
    @State private var userName = ""
    @State private var userEmail = ""
    @State private var rating = 5
    @State private var comments = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isSubmitting = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 30) {
                Text("Feedback Form")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 50)
                Group {
                    Group {
                        TextField("Name", text: $userName)
                        TextField("Email", text: $userEmail)
                    }
                    .frame(height: 60)
                    .padding(.horizontal)
                    .background(Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white, lineWidth: 2)
                    )
                    .cornerRadius(12)
                    .foregroundColor(.white)
                    
                    HStack(spacing: 15) {
                        ForEach(1...5, id: \.self) { number in
                            Button(action: {
                                rating = number
                            }) {
                                Image(systemName: "star.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(number <= rating ? .yellow : .gray)
                            }
                            .buttonStyle(.plain)
                            .focusable(true)
                        }
                    }
                    
                    TextView(comments: $comments)
                        .frame(height: 200)
                        .padding(.horizontal)
                        .background(.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white, lineWidth: 2)
                        )
                        .cornerRadius(12)
                    
                    Button(action: submitForm) {
                        Text("Submit Feedback")
                            .frame(maxWidth: 400, minHeight: 60)
                            .foregroundColor(.white)
                    }
                    .background(Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white, lineWidth: 2)
                    )
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text(alertMessage))
                }
            }
            
        }
    }
    
    
    func submitForm() {
        guard !userName.isEmpty else {
            alertMessage = "Please enter your name."
            showAlert = true
            return
        }
        
        guard !userEmail.isEmpty else {
            alertMessage = "Please enter your email."
            showAlert = true
            return
        }
        
        guard isValidEmail(userEmail) else {
            alertMessage = "Please enter a valid email address."
            showAlert = true
            return
        }
        
        isSubmitting = true
        
        let url = URL(string: "https://api.emailjs.com/api/v1.0/email/send")!
        let payload: [String: Any] = [
            "service_id": "service_46f1t6d",
            "template_id": "template_zzgb1q9",
            "user_id": "tLt5hG9jsKmKGybHz",
            "template_params": [
                "user_name": userName,
                "user_email": "aniketk561@gmail.com",
                "user_rating": rating,
                "user_comments": "It was awsm watching the videos"
            ]
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isSubmitting = false
                if let error = error {
                    alertMessage = "Failed to send feedback: \(error.localizedDescription)"
                } else {
                    alertMessage = "Thank you for your feedback!"
                    userName = ""
                    userEmail = ""
                    comments = ""
                    rating = 5
                }
                showAlert = true
            }
        }.resume()
    }
}

func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: email)
}

struct TextView: UIViewRepresentable {
    @Binding var comments: String

    func makeUIView(context: Context) -> UITextView {
        let textView = FocusableTextView()
        textView.delegate = context.coordinator
        textView.font = UIFont.systemFont(ofSize: 32)
        textView.backgroundColor = UIColor(white: 0.2, alpha: 0.3)
        textView.textColor = .white
        textView.layer.cornerRadius = 10
        textView.isScrollEnabled = true
        textView.isUserInteractionEnabled = true
        textView.textAlignment = .left

        // Add placeholder label
        let placeholder = UILabel()
        placeholder.text = "Enter your comments here..."
        placeholder.font = UIFont.systemFont(ofSize: 32)
        placeholder.textColor = UIColor.lightGray
        placeholder.numberOfLines = 0
        placeholder.tag = 999
        placeholder.translatesAutoresizingMaskIntoConstraints = false

        textView.addSubview(placeholder)

        NSLayoutConstraint.activate([
            placeholder.topAnchor.constraint(equalTo: textView.topAnchor, constant: 8),
            placeholder.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 5),
            placeholder.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -5)
        ])

        context.coordinator.placeholderLabel = placeholder
        placeholder.isHidden = !comments.isEmpty

        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = comments
        if let placeholder = uiView.viewWithTag(999) as? UILabel {
            placeholder.isHidden = !comments.isEmpty
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: TextView
        weak var placeholderLabel: UILabel?

        init(_ parent: TextView) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            parent.comments = textView.text
            placeholderLabel?.isHidden = !textView.text.isEmpty
        }
    }
}

class FocusableTextView: UITextView {
    override var canBecomeFocused: Bool {
        return true
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }
}



#Preview {
    Feedback()
}
