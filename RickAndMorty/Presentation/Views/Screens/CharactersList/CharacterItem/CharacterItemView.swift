//
//  CharacterItemView.swift
//  RickAndMorty
//
//  Created by Mario Corte on 10/20/24.
//

import SwiftUI

struct CharacterItemView: View {
    let viewModel: CharacterViewModel
    
    var body: some View {
        ItemShadingContainerView (
            content:
                VStack{
                    VStack {
                        RemoteImage(url: viewModel.image)
                            .scaledToFill()
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 250)
                    .background(Color.secondaryFill)
                    .clipped()
                    VStack(alignment: .leading, content: {
                        Text(viewModel.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.label)
                            .multilineTextAlignment(.leading)
                        HStack {
                            viewModel.status.color
                                .frame(width: 10, height: 10)
                                .clipShape(.circle)
                            Text("\(viewModel.status.description) - \(viewModel.species)")
                                .font(.headline)
                                .foregroundStyle(Color.label)
                        }
                        .padding(.top, -16)
                        Text("Last known location")
                            .font(.subheadline)
                            .foregroundStyle(Color.secondaryLabel)
                            .padding(.top, 1)
                        Text(viewModel.location)
                            .font(.body)
                            .foregroundStyle(Color.label)
                        Text("First seen in")
                            .font(.subheadline)
                            .foregroundStyle(Color.secondaryLabel)
                            .padding(.top, 1)
                        Text(viewModel.firstSeenIn)
                            .font(.body)
                            .foregroundStyle(Color.label)
                            .padding(.bottom)
                    })
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                }
        )
    }
}
