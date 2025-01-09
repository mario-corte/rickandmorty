//
//  ErrorLoadingView.swift
//  RickAndMorty
//
//  Created by Mario Corte on 11/16/24.
//

import SwiftUI

struct ErrorLoadingViewModel {
    let message: String
    let buttonTitle: String
    let buttonAction: () async -> Void
}

struct ErrorLoadingView: View {
    var viewModel: ErrorLoadingViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.message)
                .font(.footnote)
                .foregroundStyle(Color.secondaryLabel)
            Button {
                Task {
                    await viewModel.buttonAction()
                }
            } label: {
                Text(viewModel.buttonTitle)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundStyle(.accent)
            }
            .padding(.top, -2)
        }
        .padding(.bottom, 16)
    }
}
