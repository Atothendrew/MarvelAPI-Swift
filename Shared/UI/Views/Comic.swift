//
//  Comic.swift
//  DisneyMobileApp (iOS)
//
//  Created by Andrew Williamson on 6/2/22.
//

import Foundation
import SwiftUI

struct ComicCell: View {
    var book: SerializedComic
    var body: some View {
        VStack {
            HStack {
                if let thumbnail = book.thumbnail {
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
                Text(book.title!).font(.headline)
            }
            Spacer()
            HStack {
                if let id = book.id {
                    Text("ID: \(String(id))").font(.caption).padding()
                }
                if let format = book.format {
                    Text("\(format)").font(.caption)
                }
                if let pageCount = book.pageCount {
                    Text("\(pageCount) pages").font(.caption).padding()
                }
            }
        }
    }
}

struct ComicView: View {
    var book: SerializedComic
    var body: some View {
        if let image = book.thumbnail {
            VStack(alignment: .center) {
                HStack {
                    VStack {
                        Text(book.title!).font(.headline).padding()
                        AsyncImage(url: image.url) { phase in
                            if let image = phase.image {
                                image
                            } else if phase.error != nil {
                                notFoundImage
                            } else {
                                ProgressView()
                            }
                        }
                        HStack {
                            if let format = book.format {
                                Text("Format: \(format)").font(.caption)
                            }
                            if let id = book.id {
                                Text("ID: #\(String(id))").font(.caption).padding()
                            }
                            if let pageCount = book.pageCount {
                                Text("\(pageCount) pages").font(.caption).padding()
                            }
                        }
                    }
                }
                VStack {
                    if let description = book.description, description != "" {
                        ScrollView {
                            Text("\(description)")
                                    .font(.body)
                        }
                                .padding()
                    }
                    Text("Data provided by Marvel. © 2022 MARVEL")
                            .font(.caption)
                            .padding()
                }
            }
        }
    }
}

struct Comic_Preview: PreviewProvider {
    static var exampleBlob = """
                               {
                                 "id": 59551,
                                 "digitalId": 0,
                                 "title": "Spider-Man (2016) #6 (Anka Mighty Men Variant)",
                                 "issueNumber": 6,
                                 "variantDescription": "Anka Mighty Men Variant",
                                 "description": "A very long description about a comic book in which two people fight. They really don't like eachother but somehow they are forced to fight with eachother but wait... then they fall in love? Or do they keep fighting? Or are their enemies in love? Or are they their own enemies? Do the people they are fighting eventually in love? Or are they watching the movie Rocky? Why do we fight so much? Find out next time in the next issue.",
                                 "modified": "2016-07-21T17:22:23-0400",
                                 "isbn": "",
                                 "upc": "75960608314500621",
                                 "diamondCode": "",
                                 "ean": "",
                                 "issn": "",
                                 "format": "Comic",
                                 "pageCount": 32,
                                 "textObjects": [],
                                 "resourceURI": "http://gateway.marvel.com/v1/public/comics/59551",
                                 "urls": [
                                   {
                                     "type": "detail",
                                     "url": "http://marvel.com/comics/issue/59551/spider-man_2016_6_anka_mighty_men_variant/anka_mighty_men_variant?utm_campaign=apiRef&utm_source=65d4251416a8f85225e6f3f849abd855"
                                   }
                                 ],
                                 "series": {
                                   "resourceURI": "http://gateway.marvel.com/v1/public/series/20508",
                                   "name": "Spider-Man (2016 - 2018)"
                                 },
                                 "variants": [
                                   {
                                     "resourceURI": "http://gateway.marvel.com/v1/public/comics/55700",
                                     "name": "Spider-Man (2016) #6"
                                   }
                                 ],
                                 "collections": [],
                                 "collectedIssues": [],
                                 "dates": [
                                   {
                                     "type": "onsaleDate",
                                     "date": "2029-12-31T00:00:00-0500"
                                   },
                                   {
                                     "type": "focDate",
                                     "date": "2016-07-13T00:00:00-0400"
                                   }
                                 ],
                                 "prices": [
                                   {
                                     "type": "printPrice",
                                     "price": 3.99
                                   }
                                 ],
                                 "thumbnail": {
                                   "path": "http://i.annihil.us/u/prod/marvel/i/mg/a/30/56f46483efc4f",
                                   "extension": "jpg"
                                 },
                                 "images": [
                                   {
                                     "path": "http://i.annihil.us/u/prod/marvel/i/mg/a/30/56f46483efc4f",
                                     "extension": "jpg"
                                   }
                                 ],
                                 "creators": {
                                   "available": 2,
                                   "collectionURI": "http://gateway.marvel.com/v1/public/comics/59551/creators",
                                   "items": [
                                     {
                                       "resourceURI": "http://gateway.marvel.com/v1/public/creators/11575",
                                       "name": "Kris Anka",
                                       "role": "penciller (cover)"
                                     },
                                     {
                                       "resourceURI": "http://gateway.marvel.com/v1/public/creators/4300",
                                       "name": "Nick Lowe",
                                       "role": "editor"
                                     }
                                   ],
                                   "returned": 2
                                 },
                                 "characters": {
                                   "available": 0,
                                   "collectionURI": "http://gateway.marvel.com/v1/public/comics/59551/characters",
                                   "items": [],
                                   "returned": 0
                                 },
                                 "stories": {
                                   "available": 2,
                                   "collectionURI": "http://gateway.marvel.com/v1/public/comics/59551/stories",
                                   "items": [
                                     {
                                       "resourceURI": "http://gateway.marvel.com/v1/public/stories/129608",
                                       "name": "cover from Spider-Man (2016) #6 (ANKA MOP VARIANT)",
                                       "type": "cover"
                                     },
                                     {
                                       "resourceURI": "http://gateway.marvel.com/v1/public/stories/129609",
                                       "name": "story from Spider-Man (2016) #6 (ANKA MOP VARIANT)",
                                       "type": "interiorStory"
                                     }
                                   ],
                                   "returned": 2
                                 },
                                 "events": {
                                   "available": 0,
                                   "collectionURI": "http://gateway.marvel.com/v1/public/comics/59551/events",
                                   "items": [],
                                   "returned": 0
                                 }
                               }
                             """
    static var book: SerializedComic? = {
        let decoder = JSONDecoder()
        var comic: SerializedComic?
        let data = Comic_Preview.exampleBlob.data(using: .utf8)!
        comic = try? decoder.decode(SerializedComic.self, from: data)
        return comic
    }()
    static var previews: some View {
        Group {
            ComicView(book: Comic_Preview.book!)
            ComicView(book: Comic_Preview.book!).previewLayout(.fixed(width: 600, height: 300))
            ComicCell(book: Comic_Preview.book!).previewLayout(.fixed(width: 300, height: 200))
        }
    }
}
