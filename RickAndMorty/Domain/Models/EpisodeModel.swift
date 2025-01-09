//
//  EpisodeModel.swift
//  RickAndMorty
//
//  Created by Mario Corte on 10/24/24.
//

struct EpisodeModel {
    let id: Int
    let name: String
    let air_date: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
    
    init(_ episode: Episode) {
        self.id = episode.id
        self.name = episode.name
        self.air_date = episode.air_date
        self.episode = episode.episode
        self.characters = episode.characters
        self.url = episode.url
        self.created = episode.created
    }
}

