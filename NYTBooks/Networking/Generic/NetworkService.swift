//
//  NetworkProvider.swift
//  NYTBooks
//
//  Created by Wasan, Sahil on 13/01/18.
//  Copyright © 2018 Wasan, Sahil. All rights reserved.
//

import Foundation

// Protocol to provide basic functionality of for network services.
protocol NetworkService {
    associatedtype ResponseType: Decodable
    var url: URL { get }
    var method: RequestMethod { get }
    var headers: [String: String]? { get }
    
    func fetchData() -> Observer<ResponseStatus<ResponseType, NetworkError>>
    func isSuccess(response: HTTPURLResponse) -> Bool
}

// Default extensions to provide fetch date from server
extension NetworkService {
    func fetchData() -> Observer<ResponseStatus<ResponseType, NetworkError>> {
        let responseStatus = Observer(ResponseStatus<ResponseType, NetworkError>.loading)
        let request = URLRequest(url: self.url, requestType: self.method, headerFields: self.headers)
        print(request)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                responseStatus.value = .failure(error: NetworkError.unsupportedProtocol(error: error, resonse: response))
                return
            }
            if self.isSuccess(response: httpResponse) {
                guard let data = data else {
                    responseStatus.value = .failure(error: NetworkError.unsupportedProtocol(error: error, resonse: response))
                    return
                }
                do {
                    let model = try JSONDecoder().decode(ResponseType.self, from: data)
                    responseStatus.value = .success(value: model)
                } catch {
                    responseStatus.value = .failure(error: NetworkError.decodableError(error: error, resonse: response, decodable: ResponseType.self))
                }
            } else {
                responseStatus.value = .failure(error: NetworkError.unkown(error: error, resonse: response))
            }
            
        }
        task.resume()
        return responseStatus
    }
    
    func isSuccess(response: HTTPURLResponse) -> Bool {
        return response.statusCode == 200
    }
    
}

// MARK: Error Handling
enum NetworkError: LocalizedError {
    case unsupportedProtocol(error: Error?, resonse: URLResponse?)
    case decodableError(error: Error?, resonse: URLResponse?, decodable: Decodable.Type)
    case notSuccess(status: Int, error: Error?, resonse: URLResponse?)
    case emptyData(error: Error?, resonse: URLResponse?)
    case unkown(error: Error?, resonse: URLResponse?)
    
    
    public var errorDescription: String? {
        switch self {
        case .unsupportedProtocol:
            return "Only HTTP is supported for now."
        case .decodableError( _, _,let decodable):
            return "Can not able to decode: \(decodable.self)"
        case .notSuccess(let status, _, _):
            return "Api error occurred: statusCode:\(status)"
        case .emptyData:
            return "Empty Data"
        case .unkown:
            return "Unkown error occurred"
        }
    }
}

// MARK: Request and Response
enum ResponseStatus<T, E> {
    case failure(error: E) // We can make this Error
    case success(value: T)
    case loading
}
enum RequestMethod: String {
    case get = "GET", post = "POST", put = "PUT", patch = "PATCH", delete = "DELETE"
}


