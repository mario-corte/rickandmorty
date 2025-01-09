//
//  LocationsListView.swift
//  RickAndMorty
//
//  Created by Mario Corte on 10/30/24.
//

import SwiftUI

struct LocationsListView: View {
    @ObservedObject var viewModel = LocationsListViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                switch viewModel.state {
                case .Loading:
                    loadingView
                case .Data:
                    contentView
                case .DataEmpty:
                    errorView
                }
            }
            .navigationBarTitle("Locations", displayMode: .large)
        }
        .task {
            viewModel.loadLocations()
        }
        .tabItem {
            Label("Locations", systemImage: "map")
        }
    }
}

private extension LocationsListView{
    var contentView: some View {
        EmptyView()
    }
    
    var loadingView: some View {
        ProgressView()
    }
    
    var errorView: some View {
        ErrorEmptyView(viewModel: viewModel.errorViewModel)
    }
}
