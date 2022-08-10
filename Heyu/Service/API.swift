//
//  API.swift
//  Heyu
//
//  Created by João Victor Ipirajá de Alencar on 09/08/22.
//

import Foundation

struct API{
    static let domain = "http://adaspace.local/"
    
    
    static func getPosts() async -> [Post] {
        
        var urlRequest = URLRequest(url: URL(string: API.domain + "posts")!)
//        urlRequest.allHTTPHeaderFields = [
//            "x-api-key": "5cffc6c8-0e59-497e-a9ef-d1b266411e9c"
//        ]

        do {
            
            //let data = jsonString.data(using: .utf8)!

            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            let postsDecoded = try JSONDecoder().decode([Post].self, from: data)
            return postsDecoded
        } catch {
            print(error)
        }
        return []
    }
    
    
}
