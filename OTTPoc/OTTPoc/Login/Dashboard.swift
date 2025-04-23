//
//  Dashboard.swift
//  OTTPoc
//
//  Created by Aniket Kumar on 15/04/25.
//

import SwiftUI

struct Dashboard: View {
    @State private var movies: [Movie] = []
    @State private var selectedIndices: [Int] = [0, 0, 0]
    @FocusState private var focusedIndex: FocusKey?
    @State private var searchText = ""
    @State private var isListening = false
    @State private var navigateToMovieDetails = false
    @State private var selectedMovie : Movie? = nil
    
    enum FocusKey: Hashable {
        case search
        case row(Int, Int)
    }
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                VStack(spacing: 20) {
                    // Top Row - Search Bar
                    HStack {
                        Spacer()
                        VStack(alignment: .trailing, spacing: 6) {
                            SearchBar(
                                searchText: $searchText,
                                isListening: $isListening,
                                focusedIndex: $focusedIndex,
                                onVoiceTap: {
                                    isListening = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                        isListening = false
                                    }
                                }
                            )
                            .frame(width: 400, height: 40)
                            
                            if isListening {
                                BlinkingLabel(text: "🎤 Speak Now...")
                                    .padding(.top, 6)
                                    .transition(.opacity)
                            }
                        }
                        .padding(.trailing, 40)
                        .padding(.top, 20)
                    }
                    
                    // Main Content - Rows of Movies
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 40) {
                            ForEach(0..<3, id: \.self) { row in
                                VStack(alignment: .leading, spacing: 20) {
                                    Text("Movies")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .padding(.leading, 40)
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 25) {
                                            ForEach(movies.indices, id: \.self) { col in
                                                VStack(alignment: .leading, spacing: 10) {
                                                    AsyncImage(url: URL(string: movies[col].Poster)) { image in
                                                        image.resizable()
                                                    } placeholder: {
                                                        Color.gray
                                                    }
                                                    .frame(width: 400, height: selectedIndices[row] == col ? 280 : 300)
                                                    .clipShape(RoundedRectangle(cornerRadius: 25))
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 25)
                                                            .stroke(selectedIndices[row] == col ? Color.yellow : Color.clear, lineWidth: 4)
                                                    )
                                                    .scaleEffect(focusedIndex == .row(row, col) ? 1.05 : 1.0)
                                                    .shadow(color: focusedIndex == .row(row, col) ? .yellow.opacity(0.5) : .clear, radius: 10)
                                                    .id("row\(row)-\(col)")
                                                    .focusable(true)
                                                    .focused($focusedIndex, equals: .row(row, col))
                                                    .onTapGesture {
                                                        print("Tapped row \(row), col \(col)")
                                                        navigateToMovieDetails = true
                                                        selectedMovie = movies[col]
                                                    }
                                                    
                                                    .navigationDestination(isPresented: $navigateToMovieDetails) {
                                                        if let selectedObj = selectedMovie {
                                                            MovieDetail(movie: selectedObj)
                                                        }
                                                    }
                                                    
                                                    Text(movies[col].Title)
                                                        .foregroundColor(.white)
                                                        .lineLimit(1)
                                                        .font(.caption)
                                                }
                                            }
                                        }
                                        .padding(.horizontal, 40)
                                    }
                                }
                            }
                        }
                        .padding(.bottom, 60)
                    }
                }
                .background(Color.black.ignoresSafeArea())
                .onAppear {
                    movies = loadMovies() ?? []
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        focusedIndex = .row(0, 0)
                    }
                }
                .onChange(of: focusedIndex) { newFocus in
                    guard let newFocus = newFocus else { return }
                    switch newFocus {
                    case .row(let row, let index):
                        selectedIndices[row] = index
                        withAnimation {
                            proxy.scrollTo("row\(row)-\(index)", anchor: .center)
                        }
                    default: break
                    }
                }
                .onMoveCommand { direction in
                    guard let current = focusedIndex else { return }
                    switch current {
                    case .row(let row, let col):
                        var newRow = row
                        var newCol = col
                        
                        switch direction {
                        case .right:
                            newCol = min(col + 1, movies.count - 1)
                        case .left:
                            newCol = max(col - 1, 0)
                        case .down:
                            newRow = min(row + 1, 2)
                            newCol = selectedIndices[newRow]
                        case .up:
                            if row == 0 {
                                focusedIndex = .search
                                return
                            } else {
                                newRow = max(row - 1, 0)
                                newCol = selectedIndices[newRow]
                            }
                        default:
                            break
                        }
                        
                        focusedIndex = .row(newRow, newCol)
                        
                    case .search:
                        if direction == .down {
                            focusedIndex = .row(0, selectedIndices[0])
                        }
                    }
                }
            }
        }
    }
    
    struct BlinkingLabel: View {
        let text: String
        @State private var isVisible = true
        
        var body: some View {
            Text(text)
                .foregroundColor(.white)
                .opacity(isVisible ? 1 : 0)
                .animation(Animation.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: isVisible)
                .onAppear {
                    isVisible = true
                }
        }
    }

    func loadMovies() -> [Movie]? {
        guard let url = Bundle.main.url(forResource: "testData", withExtension: "json") else {
            print("File not found")
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode([Movie].self, from: data)
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
}

//// Sample Movie Model
//struct Movie: Decodable, Identifiable {
//    let id = UUID()
//    let Title: String
//    let Poster: String
//}
//
//// Dummy SearchBar
//struct SearchBar: View {
//    @Binding var searchText: String
//    @Binding var isListening: Bool
//    @Binding var focusedIndex: Dashboard.FocusKey?
//    var onVoiceTap: () -> Void
//
//    var body: some View {
//        HStack {
//            TextField("Search...", text: $searchText)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .foregroundColor(.black)
//
//            Button(action: {
//                onVoiceTap()
//            }) {
//                Image(systemName: "mic.fill")
//                    .foregroundColor(.white)
//            }
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(8)
//    }
//}

// Preview
#Preview {
    Dashboard()
}
