//
//  Feedback.swift
//  OTTPoc
//
//  Created by Aniket Kumar on 16/04/25.
//

import SwiftUI

struct Feedback: View {
    @State private var userName = ""
    @State private var userEmail = ""
    @State private var rating = 5
    @State private var comments = ""
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Feedback Form")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                TextField("Your Name", text: $userName)
                    .padding()
                
                TextField("Email (Optional)", text: $userEmail)
                    .padding()
                
                Picker("Rating", selection: $rating) {
                    ForEach(1...5, id: \.self) { number in
                        Text("\(number) Stars")
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                TextField("Comments", text: $comments)
                    .padding()
                
                Button(action: submitForm) {
                    Text("Submit Feedback")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            .padding()
            .navigationTitle("Apple TV Feedback")
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


#Preview {
    Feedback()
}
