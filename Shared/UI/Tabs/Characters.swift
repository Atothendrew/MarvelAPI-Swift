//
//  Characters.swift
//  DisneyMobileApp (iOS)
//
//  Created by Andrew Williamson on 6/2/22.
//

import Foundation
import SwiftUI

struct CharacterList: View {
    @State var characters = [SerializedCharacter]()
    @State var searchText: String = ""

    fileprivate func updateCharacters() {
        var queryParams: [URLQueryItem] = []
        if searchText != "" {
            queryParams.append(URLQueryItem(name: "nameStartsWith", value: searchText))
        }
        Characters.get(queryParams: queryParams) { characterList in
            self.characters = characterList ?? []
        }
    }

    var body: some View {
        VStack {
            if MarvelAPI.shared.privateKey == "" || MarvelAPI.shared.publicKey == "" {
                Text("Make sure you have set your keys!")
            } else {
                SearchBar(text: $searchText)
                let rows: [GridItem] = [GridItem(.flexible())]
                ScrollView(.vertical) {
                    LazyVGrid(columns: rows, alignment: .center) {
                        ForEach(characters) { character in
                            VStack {
                                if let thumbnail = character.thumbnail {
                                    AsyncImage(url: thumbnail.url) { phase in
                                        if let image = phase.image {
                                            image
                                        } else if phase.error != nil {
                                            notFoundImage
                                        } else {
                                            ProgressView()
                                        }
                                    }
                                }
                                Text(character.name ?? "Unknown")
                            }
                        }
                    }
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                }
                        .onAppear {
                            updateCharacters()
                        }
                        .onChange(of: searchText) { t in
                            updateCharacters()
                        }
            }
        }
    }
}
