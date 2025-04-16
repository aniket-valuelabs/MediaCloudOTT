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

    enum FocusKey: Hashable {
        case row(Int, Int)
    }

    var body: some View {
        ScrollViewReader { proxy in
            VStack {
                SearchBar(searchText: $searchText) {
                   print("Voice icon tapped. Start voice recognition...")
               }
           }
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    ForEach(0..<3, id: \.self) { row in
                        Text("Movies")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 20)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 25) {
                                ForEach(movies.indices, id: \.self) { col in
                                    VStack(spacing: 10) {
                                        AsyncImage(url: URL(string: movies[col].Poster)) { image in
                                            image.resizable()
                                        } placeholder: {
                                            Color.gray
                                        }
                                        .frame(width: 450, height: selectedIndices[row] == col ? 280 : 300)
                                        .clipShape(RoundedRectangle(cornerRadius: 25))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 25)
                                                .stroke(selectedIndices[row] == col ? Color.yellow : Color.white, lineWidth: 4)
                                        )
                                        .scaleEffect(focusedIndex == .row(row, col) ? 1.05 : 1.0)
                                        .shadow(color: focusedIndex == .row(row, col) ? .yellow.opacity(0.6) : .clear, radius: 10)
                                        .id("row\(row)-\(col)")
                                        .focusable(true)
                                        .focused($focusedIndex, equals: .row(row, col))
                                        .onTapGesture {
                                            print("Tapped row \(row), col \(col)")
                                        }
                                        .accessibilityLabel(Text("Movie \(col + 1) in row \(row + 1)"))
                                        .accessibilityHint(Text("Use arrow keys to navigate"))
                                        
                                        Text(movies[col].Title)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 30)
                        }
                    }
                }
                .padding(.vertical)
                .padding(.leading, 20)
            }
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
                        newCol = min(col, movies.count - 1)
                    case .left:
                        newCol = max(col, 0)
                    case .down:
                        newRow = min(row, 2)
                        newCol = selectedIndices[newRow]
                    case .up:
                        newRow = max(row, 0)
                        newCol = selectedIndices[newRow]
                    default:
                        break
                    }
                    focusedIndex = .row(newRow, newCol)
                }
            }
        }
        .navigationTitle("Movies")
    }
    
    
    func loadMovies() -> [Movie]? {
        guard let url = Bundle.main.url(forResource: "testData", withExtension: "json") else {
            print("File not found")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let movies = try decoder.decode([Movie].self, from: data)
            return movies
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
    
}
#Preview {
    Dashboard()
}
