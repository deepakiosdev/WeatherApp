//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Dipak Pandey on 28/10/18.
//  Copyright © 2018 Dipak Pandey. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

/*
 * Stracute that is used for request type, url and parameters
 */
struct RequestData {
    
    let path: String
    let method: HTTPMethod
    let params: [String: Any?]?
    let headers: [String: String]?
    
     init (path: String, method: HTTPMethod = .get, params: [String: Any?]? = nil, headers: [String: String]? = nil)
     {
        self.path = path
        self.method = method
        self.params = params
        self.headers = headers
    }
}

/*
 * Web serviecs must be implement RequestType protocol
 */
protocol RequestType {
    associatedtype ResponseType: Codable
    var data: RequestData {get set}
}

extension RequestType {
    
    func execute (
        dispatcher: NetworkDispatcher = URLSessionNetworkDispatcher.instance,
        onSuccess: @escaping (ResponseType) -> Void,
        onError: @escaping (WAError) -> Void
        ) {
        dispatcher.dispatch(
            request: self.data,
            onSuccess: { (responseData: Data) in
                
                do {
                    let jsonDecoder = JSONDecoder()
                    let result = try jsonDecoder.decode(ResponseType.self, from: responseData)
                    onSuccess(result)
                    
                } catch let error {
                    print(error)
                    onError(WAError.jsonParsingFailed)
                }
        },
            onError: { (error: WAError) in
                onError(error)
        }
        )
    }
}

protocol NetworkDispatcher {
    func dispatch(request: RequestData, onSuccess: @escaping (Data) -> Void, onError: @escaping (WAError) -> Void)
}


/*
 * Structure responsible for web service interaction
 */
struct URLSessionNetworkDispatcher: NetworkDispatcher {
    
    
    static let instance = URLSessionNetworkDispatcher()
    private init() {}
    
    func dispatch(request: RequestData, onSuccess: @escaping (Data) -> Void, onError: @escaping (WAError) -> Void) {
        guard let url = URL(string: request.path) else {
            onError(WAError.invalidURL)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        
        do {
            if let params = request.params {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
            }
        } catch let error {
            print(error)
            onError(WAError.requestParameterError)
            return
        }
        
        if let headers = request.headers {
            urlRequest.allHTTPHeaderFields = headers
        }
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            if let error = error {
                print("Web Service Error :\(error))")
                onError(WAError.unknown(error.localizedDescription))
                return
            }
            
            guard let _data = data else {
                onError(WAError.noData)
                return
            }
            let json = try? JSONSerialization.jsonObject(with: _data, options: [])
            print("Response:\(String(describing: json))")
            onSuccess(_data)
            }.resume()
    }
}
