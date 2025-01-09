//
//  CharacterViewModel.swift
//  RickAndMorty
//
//  Created by Mario Corte on 10/18/24.
//

import Foundation
import SwiftUI

struct CharacterViewModel: Identifiable, Hashable {
    let id: UUID
    let name: String
    let status: CharacterStatusViewModel
    let species: String
    let type: String
    let gender: CharacterGenderViewModel
    let origin: String
    let location: String
    let image: String
    let episodes: [String]
    let url: String
    let created: String
    var firstSeenIn: String
    var lastSeenIn: String
    var atSameLocation: Bool {
        origin == location
    }
    var appearedOnce: Bool {
        firstSeenIn == lastSeenIn
    }
    
    init(_ character: CharacterModel) {
        self.id = UUID(uuidString: String(character.id)) ?? UUID()
        self.name = character.name
        self.status = CharacterStatusViewModel(rawValue: character.status.rawValue) ?? .Unknown
        self.species = character.species.capitalized
        self.type = character.type
        self.gender = CharacterGenderViewModel(rawValue: character.gender.rawValue) ?? .Unknown
        self.origin = character.origin.capitalized
        self.location = character.location.capitalized
        self.image = character.image
        self.episodes = character.episodes
        self.url = character.url
        self.created = character.created
        self.firstSeenIn =  "Unknown"
        self.lastSeenIn =  "Unknown"
    }
}

enum CharacterStatusViewModel: String, CaseIterable {
    case Alive = "Alive"
    case Dead = "Dead"
    case Unknown = "unknown"
    
    var description: String {
        switch self {
        case .Alive: "Alive"
        case .Dead: "Dead"
        case .Unknown: "Unknown"
        }
    }
    
    var color: Color {
        switch self {
        case .Alive: .green
        case .Dead: .red
        case .Unknown: .gray
        }
    }
    
    static var items: [String] {
        CharacterStatusViewModel.allCases.map { $0.description }
    }
    
    static var filterItems: [String] {
        var items = items
        items.insert("All", at: 0)
        return items
    }
}

enum CharacterGenderViewModel: String, CaseIterable {
    case Female = "Female"
    case Male = "Male"
    case Genderless = "Genderless"
    case Unknown = "unknown"
    
    var description: String {
        switch self {
        case .Female: "Female"
        case .Male: "Male"
        case .Genderless: "Genderless"
        case .Unknown: "Unknown"
        }
    }
    
    var color: Color {
        switch self {
        case .Female: .pink
        case .Male: .blue
        case .Genderless: .ramPurple
        case .Unknown: .gray
        }
    }
    
    static var items: [String] {
        CharacterGenderViewModel.allCases.map { $0.description }
    }
    
    static var filterItems: [String] {
        var items = items
        items.insert("All", at: 0)
        return items
    }
}
