//
//  FilmJson.swift
//  Test
//
//  Created by Naresh Bojja on 11/04/25.
//

import Foundation
import Foundation

struct Movie: Codable, Identifiable {
    let id: Int
    let Title: String
    let Year: String
    let Rated: String
    let Released: String
    let Runtime: String
    let Genre: String
    let Director: String
    let Writer: String
    let Actors: String
    let Plot: String
    let Language: String
    let Country: String
    let Awards: String
    let Poster: String
    let Metascore: String
    let imdbRating: String
    let imdbVotes: String
    let imdbID: String
    let Response: String
}
