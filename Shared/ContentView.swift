//
//  ContentView.swift
//  Shared
//
//  Created by Andrew Williamson on 5/31/22.
//

import SwiftUI

// Store common image views in global memory
var notFoundImage = AsyncImage(url: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available/portrait_xlarge.jpg"))
var marvelLogoImage = AsyncImage(url: URL(string: "https://i.annihil.us/u/prod/marvel/images/mu/web/2021/marvel_insider-topnav-logo.png"))

// Track Tabbed State
enum MARVEL_APP_TABS: Int, Codable {
    case API_KEYS = 1
    case COMICS = 2
    case CHARACTERS = 3
}

struct ContentView: View {
    @State var pk: String = {
        UserDefaults.standard.value(forKey: "marvel_app_pk") as? String ?? ""
    }()
    @State var ak: String = {
        UserDefaults.standard.value(forKey: "marvel_app_ak") as? String ?? ""
    }()

    @State var selectedTab: MARVEL_APP_TABS = .API_KEYS
    var body: some View {
        TabView(selection: $selectedTab) {
            APIKeysInput(ak: $ak, pk: $pk).tabItem {
                        Image(systemName: "key.icloud.fill")
                        Text("API Keys")
                    }
                    .tag(MARVEL_APP_TABS.API_KEYS)
            ComicsList().tabItem {
                        Image(systemName: "books.vertical.fill")
                        Text("Comics List")
                    }
            .tag(MARVEL_APP_TABS.COMICS)
            CharacterList().tabItem {
                        Image(systemName: "person.crop.rectangle.stack.fill")
                        Text("Character List")
                    }
                    .tag(MARVEL_APP_TABS.CHARACTERS)
        }.colorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
