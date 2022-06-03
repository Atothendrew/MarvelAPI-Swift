//
//  MarvelAPI.swift
//  DisneyMobileApp
//
//  Created by Andrew Williamson on 5/31/22.
//

import Foundation
import SwiftUI

enum API_ENDPOINTS: String, Codable {
    case comics = "/comics"
    case characters = "/characters"
}

struct MarvelAPI: Codable {
    /// Static vars
    static let baseVersion: String = "/v1/public"
    static let baseURL: String = "https://gateway.marvel.com"
    /// Global API reference
    static var shared = MarvelAPI()

    private init() {
        privateKey = UserDefaults.standard.value(forKey: "marvel_app_pk") as? String ?? ""
        publicKey = UserDefaults.standard.value(forKey: "marvel_app_ak") as? String ?? ""
    }

    /// API properties
    var privateKey: String
    var publicKey: String

    /// Helper to create the required url query params
    static func getQueryParams() -> [URLQueryItem] {
        let shared = MarvelAPI.shared
        let timestamp = "\(Date().timeIntervalSince1970)"
        let hash = "\(timestamp)\(shared.privateKey)\(shared.publicKey)".md5
        return [
            URLQueryItem(name: "ts", value: timestamp),
            URLQueryItem(name: "hash", value: hash),
            URLQueryItem(name: "apikey", value: shared.publicKey),
        ]
    }

    /// Helper to create the URLRequest object
    static func buildURLRequest(resourceId: String? = nil, endpoint: API_ENDPOINTS, extraQueryItems: [URLQueryItem] = []) -> URLRequest {
        // Create the URL components
        let commonQueryItems = MarvelAPI.getQueryParams()
        var fullURL: URL = URL(string: baseURL + baseVersion + endpoint.rawValue)!
        if let resourceId = resourceId {
            fullURL.appendPathComponent(resourceId)
        }
        var componentURL = URLComponents(url: fullURL, resolvingAgainstBaseURL: true)
        componentURL?.queryItems = commonQueryItems + extraQueryItems
        // Build the URL request and return it
        var request = URLRequest(url: componentURL!.url!)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"
        return request
    }
}

/// Top Level API Response Wrapper
struct MarvelResponse<T: Codable>: Codable {
    let code: Int
    let status: String
    let copyright: String
    let attributionText: String
    let attributionHTML: String
    let data: MarvelDataResponse<T>
}

/// API Data Response Wrapper
struct MarvelDataResponse<T: Codable>: Codable {
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    let results: [T]
}

/// Image Metadata Wrapper
struct MarvelImage: Codable, Identifiable {
    var id: String {
        path
    }
    let path: String
    let ext: String

    enum CodingKeys: String, CodingKey {
        case path
        case ext = "extension"
    }

    var url: URL? {
        URL(string: path.replacingOccurrences(of: "http", with: "https") + "/portrait_xlarge." + ext)
    }
}








