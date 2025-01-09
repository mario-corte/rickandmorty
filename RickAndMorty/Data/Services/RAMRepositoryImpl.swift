//
//  RAMRepositoryImpl.swift
//  RickAndMorty
//
//  Created by Mario Corte on 10/18/24.
//

import Combine

struct RAMRepositoryImpl: RAMRespository {
    let dataSource: RAMDataSource
}

// MARK: Combine
extension RAMRepositoryImpl {
    func getCharacters(for page: Int, name: String) -> AnyPublisher<CharactersModel, APIError> {
        dataSource.getCharacters(for: page, name: name)
            .map { CharactersModel($0) }
            .eraseToAnyPublisher()
    }
    
    func getEpisodes(for page: Int) -> AnyPublisher<EpisodesModel, APIError> {
        dataSource.getEpisodes(for: page)
            .map { EpisodesModel($0) }
            .eraseToAnyPublisher()
    }
    
    func getEpisode(_ episode: String) -> AnyPublisher<EpisodeModel, APIError> {
        dataSource.getEpisode(episode)
            .map { EpisodeModel($0) }
            .eraseToAnyPublisher()
    }
}

// MARK: Async/Await
extension RAMRepositoryImpl {
    func getCharactersAsync(for page: Int, name: String?, status: String?, gender: String?) async throws -> CharactersModel {
        let characters = try await dataSource.getCharactersAsync(for: page, name: name, status: status, gender: gender)
        return CharactersModel(characters)
    }
    
    func getEpisodesAsync(_ episodes: [Int]) async throws -> [EpisodeModel] {
        try await dataSource.getEpisodesAsync(episodes).map { EpisodeModel($0) }
    }
}

// MARK: Callback
extension RAMRepositoryImpl {
    func getEpisodes(_ episodes: [Int], completion: @escaping (Result<[EpisodeModel], APIError>) -> Void) {
        dataSource.getEpisodes(episodes) { result in
            switch result {
            case .success(let model):
                completion(.success(model.map { EpisodeModel($0) }))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }
}
