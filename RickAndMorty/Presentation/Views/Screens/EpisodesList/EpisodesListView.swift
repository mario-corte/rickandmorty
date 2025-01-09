//
//  EpisodesListView.swift
//  RickAndMorty
//
//  Created by Mario Corte on 10/21/24.
//

import SwiftUI

struct EpisodesListView: View {
    @ObservedObject var viewModel = EpisodesListViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                switch viewModel.state {
                case .Loading:
                    loadingView
                case .DataEmpty:
                    dataEmptyView
                default:
                    contentView2
                }
            }
            .navigationBarTitle("Episodes", displayMode: .large)
        }
        .task {
            viewModel.loadEpisodes()
        }
        .tabItem {
            Label("Episodes", systemImage: "movieclapper")
        }
    }
}

private extension EpisodesListView{
    var contentView: some View {
        VStack {
            itemsView
            switch viewModel.state {
            case .Data:
                loadingView
                    .onAppear {
                        viewModel.loadMoreEpisodes()
                    }
            case .LoadingNextPage:
                loadingView
            case .Error:
                errorView
            default:
                emptyView
            }
        }
    }
    
    var contentView2: some View {
        List {
            ForEach(viewModel.seasons) { season in
                Section(isExpanded: Binding<Bool> (
                    get: {
                        viewModel.expandedSeasons.contains(season.id)
                    },
                    set: { isExpanding in
                        if isExpanding {
                            viewModel.expandedSeasons.insert(season.id)
                        } else {
                            viewModel.expandedSeasons.remove(season.id)
                        }
                    }
                )) {
                    ForEach(season.episodes) { episode in
                        EpisodeView(viewModel: episode)
                    }
                } header: {
                    SeasonHeaderView(viewModel: season)
                }
            }
            VStack() {
                switch viewModel.state {
                case .Data:
                    loadingView
                        .onAppear {
                            viewModel.loadMoreEpisodes()
                        }
                case .LoadingNextPage:
                    loadingView
                case .Error:
                    errorView
                default:
                    emptyView
                }
            }
            .frame(maxWidth: .infinity)
            .listRowInsets(EdgeInsets())
            .background(Color.fill)
        }
        .scrollContentBackground(.hidden)
        .listStyle(.sidebar)
    }
    
    var itemsView: some View {
        List {
            ForEach(viewModel.seasons) { season in
                Section(isExpanded: Binding<Bool> (
                    get: {
                        viewModel.expandedSeasons.contains(season.id)
                    },
                    set: { isExpanding in
                        if isExpanding {
                            viewModel.expandedSeasons.insert(season.id)
                        } else {
                            viewModel.expandedSeasons.remove(season.id)
                        }
                    }
                )) {
                    ForEach(season.episodes) { episode in
                        EpisodeView(viewModel: episode)
                    }
                } header: {
                    SeasonHeaderView(viewModel: season)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .listStyle(.sidebar)
    }
    
    var loadingView: some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var dataEmptyView: some View {
        ErrorEmptyView(viewModel: viewModel.errorViewModel)
    }
    
    var errorView: some View {
        ErrorLoadingView(viewModel: viewModel.errorLoadingViewModel)
            .padding(.top, 16)
            .buttonStyle(.plain)
    }
    
    var emptyView: some View {
        EmptyView()
    }
}

private struct SeasonHeaderView: View {
    let viewModel: SeasonSectionViewModel
    var body: some View {
        Text(viewModel.name)
            .fontWeight(.bold)
            .foregroundStyle(.accent)
            .listRowInsets(.init(top: 0,
                                 leading: 16,
                                 bottom: 0,
                                 trailing: 16))
    }
}
