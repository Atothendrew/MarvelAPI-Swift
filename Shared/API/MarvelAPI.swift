//
//  MarvelAPI.swift
//  DisneyMobileApp
//
//  Created by Andrew Williamson on 5/31/22.
//

import Foundation
import SwiftUI

let url: String = "https://gateway.marvel.com"
let version: String = "/v1/public"

enum API_ENDPOINTS: String, Codable {
    case comics = "/comics"
    case characters = "/characters"
}

struct MarvelAPI: Codable {
    var privateKey: String
    var publicKey: String
    var baseVersion: String = "/v1/public"
    var baseURL: String = "https://gateway.marvel.com"

    func getQueryParams() -> [URLQueryItem] {
        let timestamp = "\(Date().timeIntervalSince1970)"
        let hash = "\(timestamp)\(privateKey)\(publicKey)".md5
        return [
            URLQueryItem(name: "ts", value: timestamp),
            URLQueryItem(name: "hash", value: hash),
            URLQueryItem(name: "apikey", value: publicKey),
        ]
    }

    func buildURLComponents(resourceId: String? = nil, endpoint: API_ENDPOINTS) -> URLComponents? {
        var fullURL: URL = URL(string: url + version + endpoint.rawValue)!
        if let resourceId = resourceId {
            fullURL.appendPathComponent(resourceId)
        }
        return URLComponents(url: fullURL, resolvingAgainstBaseURL: true)
    }

    static func getRequestFor(resourceId: String? = nil, endpoint: API_ENDPOINTS, extraQueryItems: [URLQueryItem] = []) -> URLRequest {
        let marvelAPI = MarvelAPI.shared
        let commonQueryItems = marvelAPI.getQueryParams()
        let queryItems = commonQueryItems + extraQueryItems
        var componentURL = marvelAPI.buildURLComponents(resourceId: resourceId, endpoint: endpoint)
        componentURL?.queryItems = queryItems
        var request = URLRequest(url: componentURL!.url!)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"
        return request
    }

    static var shared = MarvelAPI()

    private init() {
        privateKey = UserDefaults.standard.value(forKey: "marvel_app_pk") as? String ?? ""
        publicKey = UserDefaults.standard.value(forKey: "marvel_app_ak") as? String ?? ""
    }
}

struct MarvelResponse<T: Codable>: Codable {
    let code: Int
    let status: String
    let copyright: String
    let attributionText: String
    let attributionHTML: String
    let data: MarvelDataResponse<T>
}

struct MarvelDataResponse<T: Codable>: Codable {
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    let results: [T]
}

struct MarvelImage: Codable, Identifiable {
    var id: String {
        self.path
    }
    let path: String
    let ext: String

    enum CodingKeys: String, CodingKey {
        case path
        case ext = "extension"
    }
}








