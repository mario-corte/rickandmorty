//
//  RAMDataSource.swift
//  RickAndMorty
//
//  Created by Mario Corte on 10/18/24.
//

import Foundation
import Combine

protocol RAMDataSource {
    // Combine
    func getCharacters(for page: Int, name: String) -> AnyPublisher<Characters, APIError>
    func getEpisodes(for page: Int) -> AnyPublisher<Episodes, APIError>
    func getEpisode(_ episode: String) -> AnyPublisher<Episode, APIError>
    
    // Async/Await
    func getCharactersAsync(for page: Int, name: String?, status: String?, gender: String?) async throws -> Characters
    func getEpisodesAsync(_ episodes: [Int]) async throws -> [Episode]
    
    // Callback
    func getEpisodes(_ episodes: [Int], completion: @escaping (Result<[Episode], APIError>) -> Void)
}

// MARK: - Implementation

// Combine
struct RAMDataSourceImpl: RAMDataSource {
    func getCharacters(for page: Int, name: String) -> AnyPublisher<Characters, APIError> {
        var queryItems = [APIQueryItem.Page.rawValue: String(page)]
        if !name.isEmpty {
            queryItems.updateValue(name, forKey: APIQueryItem.Name.rawValue)
        }
        
        guard let url = url(for: Endpoint.CharacterURL, queryItems: queryItems) else {
            return Fail(error: APIError.InvalidURL)
                .eraseToAnyPublisher()
        }
        
        return sendRequestPublisher(Characters.self, url: url)
    }
    
    func getEpisodes(for page: Int) -> AnyPublisher<Episodes, APIError> {
        let queryItems = [APIQueryItem.Page.rawValue: String(page)]
        guard let url = url(for: Endpoint.EpisodeURL, queryItems: queryItems) else {
            return Fail(error: APIError.InvalidURL)
                .eraseToAnyPublisher()
        }
        
        return sendRequestPublisher(Episodes.self, url: url)
    }
    
    func getEpisode(_ episode: String) -> AnyPublisher<Episode, APIError> {
        guard let url = url(for: Endpoint.EpisodeURL,
                            queryItems: [APIQueryItem.Episode.rawValue: episode])
        else {
            return Fail(error: APIError.InvalidURL)
                .eraseToAnyPublisher()
        }
        
        return sendRequestPublisher(Episode.self, url: url)
    }
}

// Async/Await
extension RAMDataSourceImpl {
    func getCharactersAsync(for page: Int, name: String?, status: String?, gender: String?) async throws -> Characters {
        var queryItems = [APIQueryItem.Page.rawValue: String(page)]
        
        if let name = name {
            queryItems.updateValue(name, forKey: APIQueryItem.Name.rawValue)
        }
        if let status = status {
            queryItems.updateValue(status, forKey: APIQueryItem.Status.rawValue)
        }
        if let gender = gender {
            queryItems.updateValue(gender, forKey: APIQueryItem.Gender.rawValue)
        }
        
        guard let url = url(for: Endpoint.CharacterURL, queryItems: queryItems) else {
            throw APIError.InvalidURL
        }
        
        return try await sendAsyncRequest(Characters.self, url: url)
    }
    
    func getEpisodesAsync(_ episodes: [Int]) async throws -> [Episode] {
        guard let url = URL(string: Endpoint.EpisodeURL)?.appending(path: episodes.description) else {
            throw APIError.InvalidURL
        }
        return try await sendAsyncRequest([Episode].self, url: url)
    }
}

// Callback
extension RAMDataSourceImpl {
    func getEpisodes(_ episodes: [Int], completion: @escaping (Result<[Episode], APIError>) -> Void) {
        guard let url = URL(string: Endpoint.EpisodeURL)?.appending(path: episodes.description) else {
            completion(.failure(APIError.InvalidURL))
            return
        }
        sendRequest([Episode].self, url: url, completion: completion)
    }
}

// MARK: - Private

private extension RAMDataSourceImpl {
    func url(for url: String, queryItems: [String: String]) -> URL? {
        guard let url = URL(string: url) else { return nil }
        let queryItems = queryItems.map { URLQueryItem(name: $0, value: $1) }
        return url.appending(queryItems: queryItems)
    }
}

// MARK: Service Requests

private extension RAMDataSourceImpl {
    // Combine
    func sendRequestPublisher<T: Decodable>(_ type: T.Type,
                                            url: URL,
                                            method: HTTPMethod = .GET) -> AnyPublisher<T, APIError> {
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        return URLSession
            .shared
            .dataTaskPublisher(for: request)
            .receive(on: RunLoop.main)
            .tryMap({ data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode)
                else {
                    throw APIError.InvalidResponse
                }
                return data
            })
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError({ error in
                switch error {
                case is DecodingError:      return APIError.FailedToDecode
                case let error as APIError: return APIError.Custom(error: error)
                default:                    return APIError.Unknown
                }
            })
            .eraseToAnyPublisher()
    }
        
    // Async/Await
    func sendAsyncRequest<T: Decodable>(_ type: T.Type,
                                        url : URL,
                                        method: HTTPMethod = .GET) async throws -> T {
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200
        else {
            throw APIError.InvalidResponse
        }
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch{
            throw APIError.FailedToDecode
        }
    }
    
    // Callback
    func sendRequest<T>(_ type: T.Type,
                        url : URL,
                        method: HTTPMethod = .GET,
                        completion: @escaping (Result<T, APIError>) -> Void) where T : Decodable {
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.InvalidResponse))
                return
            }
            do {
                let result = try JSONDecoder().decode(type, from: data)
                completion(.success(result))
            }
            catch {
                print(APIError.Custom(error: error))
                completion(.failure(APIError.FailedToDecode))
            }
        }.resume()
    }
}
