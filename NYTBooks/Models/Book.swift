//
//  Book.swift
//  NYTBooks
//
//  Created by Wasan, Sahil on 13/01/18.
//  Copyright © 2018 Wasan, Sahil. All rights reserved.
//

import Foundation

struct Book: Decodable {
    var title: String
    var publisher: String
    var description: String
}

struct RawServerResponse: Decodable {
    struct Results: Decodable {
        var lists: [List]
    }
    
    struct List: Decodable {
        var books: [Book]
    }
    
    var status: String
    var results: Results
    
    func getAllBooks() -> [Book] {
        return results.lists.flatMap { return $0.books }
    }
}
