//
//  BookService.swift
//  NYTBooks
//
//  Created by Wasan, Sahil on 13/01/18.
//  Copyright © 2018 Wasan, Sahil. All rights reserved.
//

import Foundation


// Enum to create different request of services
enum NYTBookService {
    // with help of associate type to pass the prameters and data to requests
    case requestBooks(publishDate: String)
}

// MARK: Implementation of NetworkService
extension NYTBookService: NetworkService {
    typealias ResponseType = RawServerResponse
    
    var url: URL {
        // specific handling of different type of requests
        switch self {
        case .requestBooks(let date):
            let url = NetworkingConstants.getAPIURL(.bookList) + "&published_date=\(date)"
            return URL(string: url)!
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .requestBooks:
            return .get
        }
    }
    
    var headers: [String: String]? {
            return ["Content-type": "application/json"]
    }
}

// MARK: Custom
extension NYTBookService {
    func fetchBooks() -> Observer<ResponseStatus<ResponseType, NetworkError>>  {
        return self.fetchData()
    }
}
