//
//  Comics.swift
//  DisneyMobileApp (iOS)
//
//  Created by Andrew Williamson on 6/2/22.
//

import Foundation
import SwiftUI

struct ComicsList: View {
    @State var comics = [SerializedComic]()
    @State private var searchText: String = ComicSearchOptions.name.rawValue
    @State var searchStyleSelecton: ComicSearchOptions = .name
    @State var showingFilters: Bool = false

    /// Keep track of our search options, provide some defaults
    enum ComicSearchOptions: String, Codable, CaseIterable {
        case name = "Hulk"
        case year = "2004"
        case comic_id = "101383"
    }

    /// Call the api with any filters
    fileprivate func updateComics() {
        var queryParams: [URLQueryItem] = []
        var comicID: String?
        if searchText != "" {
            var queryItem: URLQueryItem?
            switch searchStyleSelecton {
            case .name:
                queryItem = URLQueryItem(name: "titleStartsWith", value: searchText)
                break
            case .year:
                queryItem = URLQueryItem(name: "startYear", value: searchText)
                break
            case .comic_id:
                comicID = searchText
                break
            }
            if let queryItem = queryItem {
                queryParams.append(queryItem)
            }
        }
        let limit = comicID == nil ? 100 : 1
        Comics.get(resourceId: comicID, limit: limit, queryParams: queryParams) { comics in
            self.comics = comics ?? []
        }
    }

    var body: some View {
        VStack {
            if MarvelAPI.shared.privateKey == "" || MarvelAPI.shared.publicKey == "" {
                Text("Make sure you have set your keys!").accessibilityLabel("noKeysMessage")
            } else {
                if (showingFilters) {
                    SearchBar(text: $searchText)
                    HStack {
                        Picker("Search Options", selection: $searchStyleSelecton) {
                            Text("Title Prefix").tag(ComicSearchOptions.name)
                            Text("Release Year").tag(ComicSearchOptions.year)
                            Text("Comic ID").tag(ComicSearchOptions.comic_id)
                        }
                    }
                }
                NavigationView {
                    List(comics) { book in
                        NavigationLink {
                            ComicView(book: book)
                        } label: {
                            ComicCell(book: book)
                        }
                    }
                            .onAppear {
                                updateComics()
                            }
                            .onChange(of: searchText) { t in
                                updateComics()
                            }
                            .onChange(of: searchStyleSelecton) { newValue in
                                if searchText == "" || !ComicSearchOptions.allCases.filter({ op in
                                            op.rawValue == searchText
                                        })
                                        .isEmpty {
                                    searchText = newValue.rawValue
                                }
                                updateComics()
                            }
                            .navigationTitle("Comic List")
                            #if !os(macOS)
                            .listStyle(
                                    GroupedListStyle()
                            )
                            #endif
                            .toolbar {
                                ToolbarItem() {
                                    Button(showingFilters ? "Hide Filters" : "Filter") {
                                        showingFilters.toggle()
                                    }
                                }
                            }
                }
                        #if !os(macOS)
                        .navigationViewStyle(.stack)
                        #endif
            }
        }
    }
}

struct ComicView_Preview: PreviewProvider {
    static var previews: some View {
        ComicsList()
    }
}
