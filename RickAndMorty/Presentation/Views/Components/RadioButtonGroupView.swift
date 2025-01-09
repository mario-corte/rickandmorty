//
//  RadioButtonGroupView.swift
//  RickAndMorty
//
//  Created by Mario Corte on 11/27/24.
//

import SwiftUI

class RadioButtonGroup: ObservableObject {
    let title: String
    let items: [RadioButtonItem]
    var defaultItem: RadioButtonItem?
    @Published var selectedItem: RadioButtonItem?
    
    init(title: String, items: [String], defaultItem: String? = nil, selectedItem: String? = nil) {
        self.title = title
        self.items = items.map { RadioButtonItem(name: $0) }
        
        if let defaultItem = defaultItem {
            self.defaultItem = RadioButtonItem(name: defaultItem)
        }
        
        if let selectedItem = selectedItem {
            self.selectedItem = RadioButtonItem(name: selectedItem)
        }
        else {
            self.selectedItem  = self.defaultItem
        }
    }
    
    func reset() {
        selectedItem = defaultItem
    }
}

struct RadioButtonGroupView: View {
    @ObservedObject var radioButtonGroup: RadioButtonGroup
    
    var body: some View {
        VStack(alignment: .leading)  {
            Text(radioButtonGroup.title)
                .font(.headline)
                .fontWeight(.medium)
            ForEach(radioButtonGroup.items) { item in
                RadioButtonView(item: item, selectedItem: $radioButtonGroup.selectedItem)
            }
        }
    }
}


struct RadioButtonItem: Identifiable {
    let id = UUID()
    let name: String
}

struct RadioButtonView: View {
    let item: RadioButtonItem
    @Binding var selectedItem: RadioButtonItem?
    
    private var selected: Bool {
        guard let selectedItem = selectedItem else { return false }
        return item.name == selectedItem.name
    }
    
    var body: some View {
        HStack{
            Button {
                selectedItem = item
            } label: {
                HStack(alignment: .center, spacing: 16) {
                    Image(systemName: selected ? "largecircle.fill.circle" : "circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 16, height: 16)
                    Text(item.name)
                        .foregroundStyle(Color.label)
                        .font(.callout)
                }
                .foregroundColor(selected ? .accent : .label)
            }
            Spacer()
        }
    }
}
