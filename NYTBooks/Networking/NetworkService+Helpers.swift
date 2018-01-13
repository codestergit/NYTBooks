//
//  NetworkService+Helpers.swift
//  NYTBooks
//
//  Created by Wasan, Sahil on 13/01/18.
//  Copyright © 2018 Wasan, Sahil. All rights reserved.
//

import Foundation

extension URLRequest {
    init(url: URL, requestType: RequestMethod, headerFields: [String: String]?) {
        self = URLRequest(url: url)
        httpMethod = requestType.rawValue
        if let headerFields = headerFields {
            for (key, value) in headerFields {
                setValue(value, forHTTPHeaderField: key)
            }
        }
    }
}
