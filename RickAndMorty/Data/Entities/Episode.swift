//
//  Episode.swift
//  RickAndMorty
//
//  Created by Mario Corte on 10/24/24.
//

struct Episode: Codable {
    let id: Int
    let name: String
    let air_date: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
}
