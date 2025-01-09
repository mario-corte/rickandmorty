//
//  LocationsListViewModel.swift
//  RickAndMorty
//
//  Created by Mario Corte on 10/30/24.
//

import SwiftUI

class LocationsListViewModel: ObservableObject {
    @Published var state = State.Loading
    var errorViewModel: ErrorEmptyViewModel!
    
    init() {
        setupErrors()
    }
        
    enum State {
        case Loading
        case Data
        case DataEmpty
    }
    
    func loadLocations() {
        DispatchQueue.main.async {
            self.state = .Loading
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.state = .DataEmpty
        }
    }
}

private extension LocationsListViewModel {
    func setupErrors() {
        errorViewModel = ErrorEmptyViewModel(image: "RAM_Error",
                                        message: "It seems that Rick and Morty had some issues loading the locations",
                                        buttonTitle: "LET'S TRY AGAIN") {
            self.loadLocations()
        }
    }
}
