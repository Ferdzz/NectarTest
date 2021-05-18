//
//  BaseApiManager.swift
//  NectarTest
//
//  Created by Frederic Deschenes on 2021-05-18.
//

import Foundation
import Alamofire

class BaseApiManager {
    
    // TODO: This should be moved to somewhere else so it can support different environments
    let baseUrl = "https://60a3cfee7c6e8b0017e27f64.mockapi.io/api/v1/"

    /// This custom decoder serves as a way to support the non RFC3339 format. Since the API sends us a non-
    /// compliant date format, we must decode it manually
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        decoder.dateDecodingStrategy = .custom({ decoder in
            let dateString = try decoder.singleValueContainer().decode(String.self)
            return dateFormatter.date(from: dateString)!
        })
        return decoder
    }()

    
    /// Sends a request through Alamofire to the specified URL
    /// - Parameters:
    ///   - url: The URL to send the request to
    ///   - method: The request method
    ///   - onSuccess: Callback on success, includes the decoded data
    ///   - onError: Callback on error, includes the API or local error
    ///   - completion: Callback on completion, will be called regardless of success or error
    func request<Type: Decodable>(
        url: URL,
        method: HTTPMethod,
        onSuccess: @escaping (Type) -> Void,
        onError: @escaping (Error) -> Void,
        completion: @escaping () -> Void
    ) {
        AF.request(url, method: method).responseDecodable(of: Type.self, decoder: decoder) { (response) in
            if let error = response.error {
                onError(error)
            }
            
            if let value = response.value {
                onSuccess(value)
            }

            completion()
        }
    }
    
    /// Sends a request through Alamofire to the specified URL without expecting a return body
    /// - Parameters:
    ///   - url: The URL to send the request to
    ///   - method: The request method
    ///   - onSuccess: Callback on success
    ///   - onError: Callback on error, includes the API or local error
    ///   - completion: Callback on completion, will be called regardless of success or error
    func request(
        url: URL,
        method: HTTPMethod,
        onSuccess: @escaping () -> Void,
        onError: @escaping (Error) -> Void,
        completion: @escaping () -> Void
    ) {
        AF.request(url, method: method).response { (response) in
            if let error = response.error {
                onError(error)
            } else {
                onSuccess()
            }
            
            completion()
        }
    }
}
