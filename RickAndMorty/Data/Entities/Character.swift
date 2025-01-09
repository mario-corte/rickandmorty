//
//  Character.swift
//  RickAndMorty
//
//  Created by Mario Corte on 10/18/24.
//

struct Character: Codable {
    let id: Int
    let name: String
    let status: CharacterStatus
    let species: String
    let type: String
    let gender: CharacterGender
    let origin: CharacterOrigin
    let location: CharacterLocation
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

enum CharacterStatus: String, Codable {
    case Alive = "Alive"
    case Dead = "Dead"
    case Unknown = "unknown"
}

enum CharacterGender: String, Codable {
    case Female = "Female"
    case Male = "Male"
    case Genderless = "Genderless"
    case Unknown = "unknown"
}

struct CharacterOrigin: Codable {
    let name: String
    let url: String
}

struct CharacterLocation: Codable {
    let name: String
    let url: String
}
