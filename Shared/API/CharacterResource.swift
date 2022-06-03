//
//  CharacterResource.swift
//  DisneyMobileApp (iOS)
//
//  Created by Andrew Williamson on 6/2/22.
//

import Foundation

class CharacterResource: MarvelResource {
    typealias Model = SerializedCharacter
    var endpoint: API_ENDPOINTS = API_ENDPOINTS.characters
}

let Characters = CharacterResource()

struct SerializedCharacter: Codable, Identifiable {
    /*
     id (int, optional): The unique ID of the character resource.,
     name (string, optional): The name of the character.,
     description (string, optional): A short bio or description of the character.,
     modified (Date, optional): The date the resource was most recently modified.,
     resourceURI (string, optional): The canonical URL identifier for this resource.,
     urls (Array[Url], optional): A set of public web site URLs for the resource.,
     thumbnail (Image, optional): The representative image for this character.,
     comics (ComicList, optional): A resource list containing comics which feature this character.,
     stories (StoryList, optional): A resource list of stories in which this character appears.,
     events (EventList, optional): A resource list of events in which this character appears.,
     series (SeriesList, optional): A resource list of series in which this character appears.
     */
    let id: Int?
    let name: String?
    let description: String?
    let modified: String?
    let resourceURI: String?
    //let urls: [URL]?
    let thumbnail: MarvelImage?
}
