//
//  MarvelAPI.swift
//  DisneyMobileApp
//
//  Created by Andrew Williamson on 5/31/22.
//

import Foundation
import CommonCrypto
import SwiftUI




let url: String = "https://gateway.marvel.com"
let version: String = "/v1/public"

struct BaseComicResponse<T: Codable>: Codable {
    let code: Int
    let  status: String
    let copyright: String
    let  attributionText: String
    let  attributionHTML: String
    let data: BaseDataResponse<T>
}

struct BaseDataResponse<T: Codable>: Codable {
    let offset: Int
     let  limit: Int
      let  total: Int
      let  count: Int
      let  results: [T]
}

struct ComicImage: Codable, Identifiable {
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



extension String {
    var md5: String {
        let data = Data(self.utf8)
        let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
            var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5(bytes.baseAddress, CC_LONG(data.count), &hash)
            return hash
        }
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}

struct Comic: Codable, Identifiable {
    let id: Int?
    let digitalId: Int?
    let title: String?
    let description: String?
    let resourceURI: String?
    let thumbnail: ComicImage
    let images: [ComicImage]?
    
    static func getComics(completionBlock: @escaping ([Comic]?) -> Void) {
        
        let timestamp = "\(Date().timeIntervalSince1970)"
        let hash = "\(timestamp)\(privateKey)\(publicKey)".md5
        
        let commonQueryItems = [
           URLQueryItem(name: "ts", value: timestamp),
           URLQueryItem(name: "hash", value: hash),
           URLQueryItem(name: "apikey", value: publicKey)
       ]
        
        let fullURL: URL = URL(string: url + version + "/comics")!
        var componentUrl = URLComponents(url: fullURL, resolvingAgainstBaseURL: true)
        componentUrl?.queryItems = commonQueryItems
        
        var request = URLRequest(url: componentUrl!.url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"
        
        var responseObject: BaseComicResponse<Comic>?
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                error == nil
            else {                                                               // check for fundamental networking error
                print("error", error ?? URLError(.badServerResponse))
                return
            }
            
            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }
                        
            do {
                responseObject = try JSONDecoder().decode(BaseComicResponse<Comic>.self, from: data)
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


