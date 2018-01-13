//
//  BookService.swift
//  NYTBooks
//
//  Created by Wasan, Sahil on 13/01/18.
//  Copyright © 2018 Wasan, Sahil. All rights reserved.
//

import Foundation

enum NYTBookService {
    case requestBooks(publishDate: String)
    
    func fetchBooks() -> Observer<ResponseStatus<ResponseType, NetworkError>>  {
        return self.fetchData()
    }
}

// Mark : Implementation of NetworkService
extension NYTBookService: NetworkService {
    typealias ResponseType = Book
    
    var url: URL {
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

// For now implement in new class
struct Book: Decodable {
    
}
