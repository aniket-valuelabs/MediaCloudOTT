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

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 30) {
                Text("Feedback Form")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
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

                //.padding()
                
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
            .padding(40)
            .navigationTitle("Feedback")
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertMessage))
            }
        }
    }

    func submitForm() {
        if userName.isEmpty {
            alertMessage = "Please enter your name."
            showAlert = true
            return
        }
        
        // Here you can add your logic to send the feedback to a server or save it locally.
        alertMessage = "Thank you for your feedback!"
        showAlert = true
    }
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
