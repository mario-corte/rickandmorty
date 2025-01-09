//
//  Characters.swift
//  RickAndMorty
//
//  Created by Mario Corte on 10/18/24.
//

struct Characters: Codable {
    let info: CharactersInfo
    let results: [Character]
}

struct CharactersInfo: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
