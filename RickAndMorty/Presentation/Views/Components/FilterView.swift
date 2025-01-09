//
//  FilterView.swift
//  RickAndMorty
//
//  Created by Mario Corte on 11/18/24.
//

import SwiftUI

struct FilterViewModel {
    let radioButtonGroups: [RadioButtonGroup]
    let dismiss: ([String?]) -> Void
}

struct FilterView: View {
    @Environment(\.dismiss) var dismiss
    let viewModel: FilterViewModel
    
    var body: some View {
        ZStack {
            ScrollView {
                content
                    .padding()
            }
            closeButton
        }
        Divider()
            .overlay(Color.secondaryLabel)
            .padding(-8)
        footer
    }
}

private extension FilterView {
    var content: some View {
        VStack(alignment: .leading) {
            Text("Filter")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.bottom, 20)
            
            VStack(alignment: .leading, spacing: 16) {
                ForEach(viewModel.radioButtonGroups.indices, id: \.self) { index in
                    let radioButtonGroup = viewModel.radioButtonGroups[index]
                    RadioButtonGroupView(radioButtonGroup: radioButtonGroup)
                    if index < viewModel.radioButtonGroups.count - 1 {
                        Divider()
                            .overlay(Color.tertiaryLabel)
                            .padding(.vertical, 8)
                    }
                }
            }
        }
    }
    
    var footer: some View {
        HStack {
            Button {
                reset()
            } label: {
                Text("Reset")
                    .font(.headline)
                    .foregroundStyle(.accent)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 100)
                            .stroke(.accent, lineWidth: 2)
                    )
            }
            .background(Color.background)
            .clipShape(RoundedRectangle(cornerRadius: 100))
            
            Button {
                viewModel.dismiss(viewModel.radioButtonGroups.map { $0.selectedItem?.name })
                dismiss()
            } label: {
                Text("Apply")
                    .font(.headline)
                    .foregroundStyle(Color.background)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 100)
                            .stroke(.accent, lineWidth: 2)
                    )
            }
            .background(.accent)
            .clipShape(RoundedRectangle(cornerRadius: 100))
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
    
    var closeButton: some View {
        VStack{
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
            }
            .foregroundStyle(.primary)
            .frame(width: 40, height: 40)
            .padding(.trailing, 8)
            .padding(.top, 13)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
    }
}

private extension FilterView {
    func reset() {
        _ = viewModel.radioButtonGroups.map { $0.reset() }
    }
}
