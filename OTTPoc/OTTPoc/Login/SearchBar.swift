//
//  SearchBar.swift
//  OTTPoc
//
//  Created by Aniket Kumar on 15/04/25.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    @Binding var isListening: Bool
    @FocusState.Binding var focusedIndex: Dashboard.FocusKey?
    var onVoiceTap: () -> Void

    var body: some View {
        HStack {
            TextField("Search...", text: $searchText)
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white.opacity(0.5), lineWidth: 1)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.1)))
                )
                .foregroundColor(.white)
                .focused($focusedIndex, equals: .search)
                .frame(width: 340)
            
            Button(action: {
                onVoiceTap()
            }) {
                Image(systemName: "mic.fill")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Circle().fill(Color.gray.opacity(0.3)))
            }
        }
    }
}
