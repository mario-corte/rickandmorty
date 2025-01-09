//
//  ErrorEmptyView.swift
//  RickAndMorty
//
//  Created by Mario Corte on 10/22/24.
//

import SwiftUI

struct ErrorEmptyViewModel {
    let image: String
    let message: String
    let buttonTitle: String
    let buttonAction: () async -> Void
}

struct ErrorEmptyView: View {
    var viewModel: ErrorEmptyViewModel
    
    var body: some View {
        GeometryReader { geometry in
            HStack{
                VStack{
                    Image(viewModel.image)
                        .resizable()
                        .scaledToFit()
                    Text(viewModel.message)
                        .font(.subheadline)
                        .foregroundStyle(Color.label)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                    Button {
                        Task {
                            await viewModel.buttonAction()
                        }
                    } label: {
                        Text(viewModel.buttonTitle)
                            .font(.headline)
                            .foregroundStyle(Color.background)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .background(.accent)
                    .clipShape(RoundedRectangle(cornerRadius: 100))
                    .padding(.top, 20)

                }
                .frame(width: geometry.size.width * 0.8,
                       height: geometry.size.height * 0.8)
            }
            .frame(maxWidth: .infinity,  maxHeight: .infinity)
        }
    }
}
