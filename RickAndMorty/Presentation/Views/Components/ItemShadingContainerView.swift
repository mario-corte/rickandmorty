//
//  ItemShadingContainerView.swift
//  RickAndMorty
//
//  Created by Mario Corte on 10/29/24.
//

import SwiftUI

struct ItemShadingContainerView<Content: View>: View {
    @Environment(\.colorScheme) var colorScheme
    let content: Content
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(colorScheme == .light ? .background : Color.fill)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(radius: colorScheme == .light ? 8 : 0)
            content
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}
