//
//  MovieDetail.swift
//  OTTPoc
//
//  Created by Janakiraman Kanagaraj on 23/04/25.
//
import SwiftUI

struct MovieDetail: View {
    let movie: Movie
    @Environment(\.dismiss) private var dismiss
    @State private var navigateToFeedBack = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .topTrailing) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 40) {
                        AsyncImage(url: URL(string: movie.Poster)) { image in
                            image.resizable()
                                .scaledToFit()
                                .cornerRadius(25)
                        } placeholder: {
                            Color.gray.opacity(0.5)
                        }
                        .frame(width: 600, height: 420)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text(movie.Title)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .accessibilityLabel("Movie Title")
                            
                            Text(movie.Year)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .accessibilityLabel("Release Year")
                            
                            Text(movie.Genre)
                                .font(.caption)
                                .foregroundColor(.gray)
                                .accessibilityLabel("Genre")
                            
                            Text(movie.Plot)
                                .font(.body)
                                .lineLimit(nil)
                                .foregroundColor(.white)
                                .accessibilityLabel("Plot Summary")
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                }
                // Top-right aligned info icon
                Button {
                    navigateToFeedBack = true
                } label: {
                    Text("Give Feedback")
                        .font(.subheadline)
                }
            }
            .navigationTitle("Movie Detail")
        }
        .edgesIgnoringSafeArea(.all)
        .navigationDestination(isPresented: $navigateToFeedBack) {
            Feedback()
        }

    }
    
}

// Preview
#Preview {
    MovieDetail(movie: Movie(id: 0, Title: "Jk", Year: "2024", Rated: "U/A", Released: "2025", Runtime: "3:00", Genre: "Comedy", Director: "Johny", Writer: "Nolan", Actors: "Chris", Plot: "Cine", Language: "Tamil", Country: "IN", Awards: "Gines", Poster: "Yes", Metascore: "9.0", imdbRating: "10.0", imdbVotes: "1000k", imdbID: "00012", Response: "Hit"))
}

