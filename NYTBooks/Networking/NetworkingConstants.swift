//
//  NetworkingConstants.swift
//  NYTBooks
//
//  Created by Wasan, Sahil on 13/01/18.
//  Copyright © 2018 Wasan, Sahil. All rights reserved.
//

import Foundation

struct NetworkingConstants {
    static let baseURL = "https://api.nytimes.com"
    static let apiKey = "76363c9e70bc401bac1e6ad88b13bd1d"
    
    // endpoints to add to service urls.
    enum EndPoint: String {
        case bookList = "/svc/books/v2/lists/overview.json"
    }
}

extension NetworkingConstants {
    static func getAPIURL(_ endpoint: EndPoint) -> String {
        return baseURL + endpoint.rawValue + "?api-key=\(apiKey)"
    }
    
}
