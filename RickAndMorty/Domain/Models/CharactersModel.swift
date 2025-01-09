//
//  CharactersEntity.swift
//  RickAndMorty
//
//  Created by Mario Corte on 10/18/24.
//

struct CharactersModel {
    let count: Int
    let pages: Int
    var next: String?
    var prev: String?
    let characters: [CharacterModel]
    
    init(_ characters: Characters) {
        self.count = characters.info.count
        self.pages = characters.info.pages
        self.characters = characters.results.map { CharacterModel($0) }
    }
}
