//
//  EpisodesViewModel.swift
//  RickAndMorty
//
//  Created by Mario Corte on 10/22/24.
//

import SwiftUI
import Combine

struct SeasonSectionViewModel: Identifiable {
    let id: Int
    let name: String
    var episodes: [EpisodeViewModel]
    
    init(id: Int, episodes: [EpisodeViewModel]) {
        self.id = id
        self.name = "Season \(id)"
        self.episodes = episodes
    }
}

class EpisodesListViewModel: ObservableObject {
    @Published var state = State.Loading
    @Published var seasons = [SeasonSectionViewModel]()
    @Published var expandedSeasons = Set<Int>()
    
    var errorViewModel: ErrorEmptyViewModel!
    var errorLoadingViewModel: ErrorLoadingViewModel!
    
    private let useCase = GetEpisodesUseCase()
    private var cancellables = Set<AnyCancellable>()
    
    private var pages: Int = 0
    private var currentPage: Int = 1
    
    enum State {
        case Loading
        case Data
        case DataEmpty
        case LoadingNextPage
        case Error
        case Empty
    }
    
    init() {
        setupErrors()
    }
    
    func loadEpisodes() {
        if !seasons.isEmpty { return }
        getEpisodes(at: currentPage)
    }
    
    func loadMoreEpisodes()  {
        if currentPage == pages {
            state = .Empty
            return
        }
        state = .LoadingNextPage
        getEpisodes(at: currentPage + 1)
    }
}

private extension EpisodesListViewModel {
    func setupErrors() {
        errorViewModel = ErrorEmptyViewModel(image: "RAM_Error",
                                        message: "It seems that Rick and Morty had some issues loading the episodes",
                                        buttonTitle: "LET'S TRY AGAIN") {
            self.loadEpisodes()
        }
        
        errorLoadingViewModel = ErrorLoadingViewModel(message: "There were some issues loading more content",
                                                      buttonTitle: "Try Again") {
            self.retryGettingEpisodes()
        }
    }
}

private extension EpisodesListViewModel {
    func retryGettingEpisodes() {
        DispatchQueue.main.async {
            self.state = .Loading
        }
        getEpisodes(at: self.currentPage)
    }
    
    func getEpisodes(at page: Int) {
        useCase.getEpisodes(for: page)
            .sink { [weak self] completion in
                if case let .failure(error) = completion,
                   let errorDescription = error.errorDescription {
                    print(errorDescription)
                    if page == 1 {
                        self?.state = .DataEmpty
                        return
                    }
                    self?.state = .Error
                }
            } receiveValue: { [weak self] result in
//                if page == 2 {
//                    self?.state = .Error
//                    return
//                }
                self?.currentPage = page
                self?.pages = result.pages
                self?.addEpisodes(result.episodes.map { EpisodeViewModel($0) })
                self?.state = .Data
            }
            .store(in: &self.cancellables)
    }
    
    func addEpisodes(_ episodes: [EpisodeViewModel]?) {
        guard let episodes = episodes else { return }
        for episodeViewModel in episodes {
            let episode = episodeViewModel.episode
            let episodeComponents = episode.split(separator: "E")
            let seasonID = Int(episodeComponents.first!.dropFirst())!
            
            if let index = seasons.firstIndex(where: { $0.id == seasonID }) {
                seasons[index].episodes.append(episodeViewModel)
            }
            else {
                let season = SeasonSectionViewModel(id: seasonID, episodes: [episodeViewModel])
                expandedSeasons.insert(seasonID)
                seasons.append(season)
            }
        }
    }
}
