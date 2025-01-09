//
//  RAMRespository.swift
//  RickAndMorty
//
//  Created by Mario Corte on 11/25/24.
//

import Combine

protocol RAMRespository {
    // Combine
    func getCharacters(for page: Int, name: String) -> AnyPublisher<CharactersModel, APIError>
    func getEpisodes(for page: Int) -> AnyPublisher<EpisodesModel, APIError>
    func getEpisode(_ episode: String) -> AnyPublisher<EpisodeModel, APIError>
    
    // Async/Await
    func getCharactersAsync(for page: Int, name: String?, status: String?, gender: String?) async throws -> CharactersModel
    func getEpisodesAsync(_ episodes: [Int]) async throws -> [EpisodeModel]
    
    // Callback
    func getEpisodes(_ episodes: [Int], completion: @escaping (Result<[EpisodeModel], APIError>) -> Void)
}
