//
//  GetEpisodesUseCase.swift
//  RickAndMorty
//
//  Created by Mario Corte on 10/30/24.
//

import Combine

struct GetEpisodesUseCase {
    let repository: RAMRespository = RAMRepositoryImpl(dataSource: RAMDataSourceImpl())
    
    // Combine
    func getEpisodes(for page: Int) -> AnyPublisher<EpisodesModel, APIError> {
        repository.getEpisodes(for: page)
    }
     
    // Async/Await
    func getEpisodes(_ episodes: [Int]) async throws -> [EpisodeModel] {
        try await repository.getEpisodesAsync(episodes)
    }
}
