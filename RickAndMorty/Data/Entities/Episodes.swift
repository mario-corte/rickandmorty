//
//  Episodes.swift
//  RickAndMorty
//
//  Created by Mario Corte on 10/30/24.
//

struct Episodes: Codable {
    let info: EpisodesInfo
    let results: [Episode]
}

struct EpisodesInfo: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
