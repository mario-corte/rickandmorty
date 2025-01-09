//
//  CharactersListViewModel.swift
//  RickAndMorty
//
//  Created by Mario Corte on 10/18/24.
//

import SwiftUI
import Combine

class CharactersListViewModel: ObservableObject {
    @Published var state = State.Loading
    @Published var characters = [CharacterViewModel]()
    
    @Published var searchText = String(){
        didSet {
            if searchText == oldValue { return }
            if searchText.isEmpty {
                Task {
                    await filterCharactersAsync()
                }
            }
        }
    }
    
    @Published var debouncedSearchText = String() {
        didSet {
            if debouncedSearchText == oldValue { return }
            Task {
                await filterCharactersAsync()
            }
        }
    }
    
    @Published var showingFilterSheet = false
    
    // Vieew Models
    var filterViewModel: FilterViewModel!
    var errorViewModel: ErrorEmptyViewModel!
    var errorLoadingViewModel: ErrorLoadingViewModel!
    
    // Use Cases
    private let getCharactersUseCase = GetCharactersUseCase()
    private let getEpisodesUseCase = GetEpisodesUseCase()
    
    // Filters
    private var defaultStatus: String? = CharacterStatusViewModel.filterItems.first
    private var selectedStatus: String?
    
    private var defaultGender: String? = CharacterGenderViewModel.filterItems.first
    private var selectedGender: String?
    
    // Pagination
    private var pages: Int = 0
    private var currentPage: Int = 1
    
    // Combine Subscriptions
    private var subscriptions = Set<AnyCancellable>()
    
    // View State
    enum State {
        case Loading
        case Data
        case DataEmpty
        case LoadingNextPage
        case Error
        case Empty
    }
    
    // Initializer
    init() {
        setupSearch()
        setupFilters()
        setupErrors()
    }
     
    // Filters
    func updateFilters() {
        setupFilters()
    }
            
    // Combine
    func loadCharacters() {
        if !characters.isEmpty { return }
        state = .Loading
        getCharacters(at: currentPage)
    }
    
    func loadMoreCharacters() {
        if currentPage == pages {
            state = .Empty
            return
        }
        state = .LoadingNextPage
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.getCharacters(at: self.currentPage + 1)
        }
    }
    
    // Async/Await
    func loadCharactersAsync() async {
        if !characters.isEmpty { return }
        await MainActor.run {
            state = .Loading
        }
        await getCharactersAsync(at: currentPage)
    }
    
    func loadMoreCharactersAsync() async {
        await MainActor.run {
            if currentPage == pages {
                state = .Empty
                return
            }
            state = .LoadingNextPage
        }
        await getCharactersAsync(at: currentPage + 1)
    }
}

// MARK: - Private

private extension CharactersListViewModel {
    func setupSearch() {
        $searchText
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                if text.isEmpty { return }
                self?.debouncedSearchText = text
            }
            .store(in: &subscriptions)
    }
    
    func setupFilters() {
        filterViewModel = FilterViewModel(radioButtonGroups: [
            RadioButtonGroup(title: "Status",
                             items: CharacterStatusViewModel.filterItems,
                             defaultItem: defaultStatus,
                             selectedItem: selectedStatus),
            RadioButtonGroup(title: "Gender",
                             items: CharacterGenderViewModel.filterItems,
                             defaultItem: defaultGender,
                             selectedItem: selectedGender)
        ], dismiss: { selectedItems in
            self.selectedStatus = selectedItems[0]
            self.selectedGender = selectedItems[1]
            Task {
                await self.filterCharactersAsync()
            }
        })
    }
    
    func setupErrors() {
        errorViewModel = ErrorEmptyViewModel(image: "RAM_Error",
                                        message: "It seems that Rick and Morty had some issues loading the characters",
                                        buttonTitle: "LET'S TRY AGAIN") {
            await self.retryGettingCharactersAsync()
        }
        
        errorLoadingViewModel = ErrorLoadingViewModel(message: "There were some issues loading more content",
                                                      buttonTitle: "Try Again") {
            await self.retryGettingCharactersAsync()
        }
    }
}

// MARK: Combine

private extension CharactersListViewModel {
    func filterCharacters() {
        characters = []
        currentPage = 1
        loadCharacters()
    }
        
    func retryGettingCharacters() {
        state = .Loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.getCharacters(at: self.currentPage)
        }
    }
    
    func getCharacters(at page: Int) {
        getCharactersUseCase.getCharacters(for: page, name: searchText)
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
                print(result)
//                if page == 2 {
//                    self?.state = .Error
//                    return
//                }
                self?.currentPage = page
                self?.pages = result.pages
                self?.characters.append(contentsOf: result.characters.map { CharacterViewModel($0) } )
                self?.state = .Data
            }
            .store(in: &self.subscriptions)
    }
}

// MARK: Async/Await

private extension CharactersListViewModel {
    func filterCharactersAsync() async {
        await MainActor.run {
            characters = []
        }
        currentPage = 1
        await loadCharactersAsync()
    }
    
    func retryGettingCharactersAsync() async {
        await MainActor.run {
            state = .Loading
        }
        await getCharactersAsync(at: currentPage)
    }
    
    func getCharactersAsync(at page: Int) async {
        do {
            let name = searchText.isEmpty ? nil : searchText
            let status = selectedStatus == defaultStatus ? nil : selectedStatus
            let gender = selectedGender == defaultGender ? nil : selectedGender
            
            let characters = try await getCharactersUseCase.getCharactersAsync(for: page, name: name, status: status, gender: gender)
            
//            if page == 2 {
//                await MainActor.run {
//                    state = .Error
//                }
//                return
//            }
            
            self.currentPage = page
            self.pages = characters.pages

            var charactersList = [CharacterViewModel]()
            for character in characters.characters {
                var character = CharacterViewModel(character)
                let episodes = character.episodes
                
                let firstEpisode = Int(episodes.first?.components(separatedBy: "/").last ?? "0") ?? 0
                let lastEpisode = Int(episodes.last?.components(separatedBy: "/").last ?? "0") ?? 0
                
                do {
                    let episodes = try await self.getEpisodesUseCase.getEpisodes([firstEpisode,lastEpisode])
                    
                    if let firstSeenIn = episodes.first?.name {
                        character.firstSeenIn = firstSeenIn
                    }
                    
                    if let lastSeenIn = episodes.last?.name {
                        character.lastSeenIn = lastSeenIn
                    }
                    
                    charactersList.append(character)
                }
                catch {
                    print(error)
                }
            }
            
            await MainActor.run { [charactersList] in
                self.characters.append(contentsOf: charactersList)
                self.state = .Data
            }
        }
        catch {
            print(error.localizedDescription)
            await MainActor.run {
                if page == 1 {
                    state = .DataEmpty
                    return
                }
                state = .Error
            }
        }
    }
}
