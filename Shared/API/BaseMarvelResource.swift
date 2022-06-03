//
//  MarvelAPIResource.swift
//  DisneyMobileApp (iOS)
//
//  Created by Andrew Williamson on 6/2/22.
//

import Foundation
import SwiftUI

/// Generic protocol for representing an Endpoint we can call. Tested with Comics and Characters.
protocol MarvelResource: Codable {
    associatedtype Model: Codable, Identifiable
    var endpoint: API_ENDPOINTS { get }
    func get(resourceId: String?, limit: Int, queryParams: [URLQueryItem]?, completionBlock: @escaping ([Model]?) -> Void)
}

/// Default implementation of the get that casts the result data type to the proper model object
extension MarvelResource {
    func get(resourceId: String? = nil, limit: Int = 100, queryParams: [URLQueryItem]? = nil, completionBlock: @escaping ([Model]?) -> Void) {
        var extraQueryItems = [URLQueryItem(name: "limit", value: String(limit))]
        if let queryParams = queryParams {
            for param in queryParams {
                extraQueryItems.append(param)
            }
        }
        let request = MarvelAPI.buildURLRequest(resourceId: resourceId, endpoint: self.endpoint, extraQueryItems: extraQueryItems)
        var responseObject: MarvelResponse<Model>?
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                    let data = data,
                    let response = response as? HTTPURLResponse,
                    error == nil
            else {
                print("error", error ?? URLError(.badServerResponse))
                completionBlock(nil)
                return
            }
            /// check for http errors
            guard (200...299) ~= response.statusCode else {
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                completionBlock(nil)
                return
            }
            do {
                /// Decode the json to our associated type
                responseObject = try JSONDecoder().decode(MarvelResponse<Model>.self, from: data)
                /// Call our completion block to perform callback operations
                completionBlock(responseObject?.data.results)
            } catch {
                print(error)
                if let responseString = String(data: data, encoding: .utf8) {
                    print("responseString = \(responseString)")
                } else {
                    print("unable to parse response as string")
                }
            }
        }
        task.resume()
    }
}



