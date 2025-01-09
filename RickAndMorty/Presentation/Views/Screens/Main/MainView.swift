//
//  MainView.swift
//  RickAndMorty
//
//  Created by Mario Corte on 10/26/24.
//

import SwiftUI

struct MainView: View {
    init() {
//        UITabBar.appearance().barTintColor = .systemBackground
//        UITabBar.appearance().unselectedItemTintColor = .gray
    }
    
    var body: some View {
        TabView {
            CharactersListView()
            EpisodesListView()
            LocationsListView()
            AboutView()
        }
//        .tint(.accent)
    }
}
