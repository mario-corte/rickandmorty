//
//  CharacterDetailView.swift
//  RickAndMorty
//
//  Created by Mario Corte on 10/22/24.
//

import SwiftUI

struct CharacterDetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var showTitle = false
    let viewModel: CharacterDetailViewModel
    
    var body: some View {
        ScrollView  {
            HeaderView(viewModel: viewModel)
            ContentView(viewModel: viewModel)
        }
        .scrollIndicators(.hidden)
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .toolbarTitleDisplayMode(.inline)
        .navigationTitle(showTitle ? viewModel.characterViewModel.name : String())
        .onScrollGeometryChange(for: Double.self) { geometry in
            geometry.contentOffset.y
        } action: { _, newValue in
            showTitle = newValue > 2
        }
    }
}

struct HeaderView: View {
    let viewModel: CharacterDetailViewModel
    
    var body: some View {
        let headerHeidht:CGFloat = 500
        GeometryReader { geometry in
            let offsetY = geometry.frame(in: .global).minY
            let isScrolled = offsetY > 0
            Spacer()
                .frame(height: isScrolled ? headerHeidht + offsetY : headerHeidht)
                .background {
                    RemoteImage(url: viewModel.characterViewModel.image)
                        .scaledToFill()
                        .offset(y: isScrolled ? -offsetY : 0)
                        .scaleEffect(isScrolled ? offsetY/1000 + 1 : 1)
//                        .blur(radius: isScrolled ? offsetY/50 : 0)
                }
        }
        .frame(height: headerHeidht)
    }
}

struct ContentView: View {
    var viewModel: CharacterDetailViewModel
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, content: {
                Text(viewModel.characterViewModel.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.label)
                HStack {
                    viewModel.characterViewModel.status.color
                        .frame(width: 10, height: 10)
                        .clipShape(.circle)
                    Text("\(viewModel.characterViewModel.status.description) - \(viewModel.characterViewModel.species)")
                        .font(.headline)
                        .foregroundStyle(Color.label)
                }
                .padding(.top, -16)
                
                Text("Gender")
                    .font(.subheadline)
                    .foregroundStyle(Color.secondaryLabel)
                    .padding(.top, 1)
                Text(viewModel.characterViewModel.gender.description)
                    .foregroundStyle(Color.label)
                
                Text("Originary from")
                    .font(.subheadline)
                    .foregroundStyle(Color.secondaryLabel)
                    .padding(.top, 1)
                Text(viewModel.characterViewModel.origin)
                    .foregroundStyle(Color.label)
                
                if !viewModel.characterViewModel.atSameLocation {
                    Text("Current location")
                        .font(.subheadline)
                        .foregroundStyle(Color.secondaryLabel)
                        .padding(.top, 1)
                    Text(viewModel.characterViewModel.location)
                        .foregroundStyle(Color.label)
                }
                
                if viewModel.characterViewModel.appearedOnce {
                    Text("Seen in")
                        .font(.subheadline)
                        .foregroundStyle(Color.secondaryLabel)
                        .padding(.top, 1)
                    Text(viewModel.characterViewModel.firstSeenIn)
                        .foregroundStyle(Color.label)
                        .padding(.bottom, 10)
                }
                else {
                    Text("Last known episode")
                        .font(.subheadline)
                        .foregroundStyle(Color.secondaryLabel)
                        .padding(.top, 1)
                    Text(viewModel.characterViewModel.lastSeenIn)
                        .foregroundStyle(Color.label)
                    
                    Text("First seen in")
                        .font(.subheadline)
                        .foregroundStyle(Color.secondaryLabel)
                        .padding(.top, 1)
                    Text(viewModel.characterViewModel.firstSeenIn)
                        .foregroundStyle(Color.label)
                        .padding(.bottom, 10)
                }
            })
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .padding(.bottom, 60)
        }
        .background(.background)
        .containerShape(RoundedRectangle(cornerRadius: 20))
        .offset(y: -20)
    }
}

private extension CharacterDetailView {
    var backButton : some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "chevron.backward.circle.fill")
        }
        .foregroundStyle(.primary)
    }
}
