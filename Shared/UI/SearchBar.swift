//
//  SearchBar.swift
//  DisneyMobileApp (iOS)
//
//  Created by Andrew Williamson on 6/2/22.
//

import Foundation
import SwiftUI

/// From: https://sanzaru84.medium.com/swiftui-how-to-add-a-clear-button-to-a-textfield-9323c48ba61c
struct TextFieldClearButton: ViewModifier {
    @Binding var text: String

    func body(content: Content) -> some View {
        HStack {
            content
            if !text.isEmpty {
                Button(
                        action: { self.text = "" },
                        label: {
                            Image(systemName: "delete.left")
                                    .foregroundColor(Color(.clear))
                        }
                )
            }
        }
    }
}

/// Adapted from: https://blckbirds.com/post/how-to-create-a-search-bar-with-swiftui/
struct SearchBar: View {
    @Binding var text: String
    @State private var isEditing = false
    var body: some View {
        HStack {
            TextField("Search...", text: $text)
                    .padding(7)
                    .padding(.horizontal, 25)
                    #if !os(macOS)
                    .background(Color(.systemGray6))
                    #else
                    .background(.clear)
                    #endif
                    .cornerRadius(8)
                    .padding(.horizontal, 10)
                    .onTapGesture {
                        self.isEditing = true
                    }
                    .modifier(TextFieldClearButton(text: $text)).padding()
            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.text = ""
                }) {
                    Text("Cancel")
                }
                        .padding(.trailing, 10)
                        .transition(.move(edge: .trailing))
                        .animation(.default)
            }
        }
    }
}

