//
//  SearchBar.swift
//  OTTPoc
//
//  Created by Aniket Kumar on 15/04/25.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    var onVoiceTap: () -> Void

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField("Search...", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(.vertical, 10)
                .padding(.horizontal, 5)

            Button(action: {
                onVoiceTap()
            }) {
                Image(systemName: "mic.fill")
                    .foregroundColor(.blue)
            }
            .padding(.leading, 5)
        }
        .padding(.horizontal, 15)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.lightGray))
        )
        .padding(.horizontal)
    }
}
