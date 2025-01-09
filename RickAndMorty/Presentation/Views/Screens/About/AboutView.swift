//
//  AboutView.swift
//  RickAndMorty
//
//  Created by Mario Corte on 10/26/24.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    infoView
                    profileView
                }
                .padding(.horizontal)
                .padding(.top, 4)
                .padding(.bottom)
            }
            .scrollIndicators(.hidden)
            .navigationBarTitle("About", displayMode: .large)
        }
        .tabItem {
            Label("About", systemImage: "info.bubble")
        }
    }
}

private extension AboutView {
    var infoView: some View {
        ItemShadingContainerView(
            content:
                VStack {
                    Image("RAM_Portal")
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 250)
                        .clipped()
                        .background(Color.secondaryFill)
                    VStack(alignment: .leading) {
                        Text("The Rick and Morty API")
                            .font(.largeTitle)
                            .fontWeight(.black)
                        Text("The Rick and Morty API is a REST(ish) and GraphQL API based on the television show Rick and Morty. You will have access to about hundreds of characters, images, locations and episodes. The Rick and Morty API is filled with canonical information as seen on the TV show.")
                            .font(.callout)
                            .padding(.top, 1)
                        Link(destination: URL(string: "https://rickandmortyapi.com")!) {
                            Text("Visit the official API website")
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .underline()
                        }
                        .padding(.vertical)
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
        )
    }
    
    var profileView: some View {
        ItemShadingContainerView(
            content:
                VStack(alignment: .leading) {
                    Text("Mobile app developed by")
                        .font(.footnote)
                        .foregroundStyle(Color.secondaryLabel)
                        .padding(.top)
                    Text("Mario Corte González")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top, -2)
                    Text("Software Engineer\nMobile Applications Developer\nSwiftUI · Swift · Objective-C")
                        .font(.footnote)
                        .padding(.top, -6)
                    Link(destination: URL(string: "https://linkedin.com/in/mario-cort3")!) {
                        Image("Linkedin")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .tint(.white)
                            .padding(.vertical)
                            .padding(.horizontal, 25)
                            .frame(height: 50)
                            .background(Color.linkedin)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding(.top, 14)
                    .padding(.bottom)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
        )
    }
}
