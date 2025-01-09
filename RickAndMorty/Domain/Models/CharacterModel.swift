//
//  CharacterModel.swift
//  RickAndMorty
//
//  Created by Mario Corte on 10/19/24.
//

struct CharacterModel {
    let id: Int
    let name: String
    let status: CharacterStatusModel
    let species: String
    let type: String
    let gender: CharacterGenderModel
    let origin: String
    let originUrl: String
    let location: String
    let locationUrl: String
    let image: String
    let episodes: [String]
    let url: String
    let created: String
    
    init(_ character: Character) {
        self.id = character.id
        self.name = character.name
        self.status = CharacterStatusModel(rawValue: character.status.rawValue) ?? .Unknown
        self.species = character.species
        self.type = character.type
        self.gender = CharacterGenderModel(rawValue: character.gender.rawValue) ?? .Unknown
        self.origin = character.origin.name
        self.originUrl = character.origin.url
        self.location = character.location.name
        self.locationUrl = character.location.url
        self.image = character.image
        self.episodes = character.episode
        self.url = character.url
        self.created = character.created
    }
}

enum CharacterStatusModel: String {
    case Alive = "Alive"
    case Dead = "Dead"
    case Unknown = "unknown"
}

enum CharacterGenderModel: String {
    case Female = "Female"
    case Male = "Male"
    case Genderless = "Genderless"
    case Unknown = "unknown"
}
