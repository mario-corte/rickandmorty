//
//  CharactersListView.swift
//  RickAndMorty
//
//  Created by Mario Corte on 10/18/24.
//

import SwiftUI

struct CharactersListView: View {
    @ObservedObject private var viewModel = CharactersListViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                switch viewModel.state {
                case .Loading:
                    loadingView
                case .DataEmpty:
                    dataEmptyView
                default:
                    contentView
                }
            }
            .navigationBarTitle("Characters", displayMode: .large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.showingFilterSheet.toggle()
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease")
                    }
                    .sheet(isPresented: $viewModel.showingFilterSheet) {
                        viewModel.updateFilters()
                    } content: {
                        FilterView(viewModel: viewModel.filterViewModel)
                    }
                }
            }
        }
        .searchable(text: $viewModel.searchText, prompt: "Character name")
        .task {
            await viewModel.loadCharactersAsync()
        }
        .tabItem {
            Label("Characters", systemImage: "atom")
        }
    }
}

private extension CharactersListView {
    var contentView: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                itemsView
                switch viewModel.state {
                case .Data:
                    loadingView
                        .onAppear {
                            Task {
                                await viewModel.loadMoreCharactersAsync()
                            }
                        }
                case .LoadingNextPage:
                    loadingView
                case .Error:
                    errorLoadingView
                default:
                    emptyView
                }
            }
            .padding(.horizontal)
        }
    }
    
    var itemsView: some View {
        ForEach(viewModel.characters, id: \.self) { character in
            NavigationLink(destination: CharacterDetailView(viewModel: CharacterDetailViewModel(characterViewModel: character))) {
                CharacterItemView(viewModel: character)
                    .padding(.top, 4)
            }
        }
    }
    
    var loadingView: some View {
        ProgressView()
            .padding(.top, 6)
            .padding(.bottom, 32)
    }
    
    var dataEmptyView: some View {
        ErrorEmptyView(viewModel: viewModel.errorViewModel)
    }
        
    var errorLoadingView: some View {
        ErrorLoadingView(viewModel: viewModel.errorLoadingViewModel)
    }
    
    var emptyView: some View {
        EmptyView()
    }
}
