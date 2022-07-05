//
//  NetworkManager.swift
//  ForecastWeather
//
//  Created by soroush amini araste on 7/3/22.
//

import Foundation
import Combine

struct APIErrorMessage: Decodable {
    var cod: Int
    var message: String
}

enum APIError: LocalizedError {
    /// Invalid request, e.g. invalid URL
    case invalidRequestError(String)
    
    /// Indicates an error on the transport layer, e.g. not being able to connect to the server
    case transportError
    
    /// Received an invalid response, e.g. non-HTTP result
    case invalidResponse
    
    /// Server-side validation error
    case validationError(String)
    
    /// The server sent data in an unexpected format
    case decodingError(Error)
    
    ///401 error maybe access token is invalid
    case unauthorized
    
    case someServerIssues
    
    /// General server-side error. If `retryAfter` is set, the client can send the same request after the given time.
    case serverError(statusCode: Int, reason: String? = nil, retryAfter: String? = nil)
    
    var errorDescription: String? {
        switch self {
        case .invalidRequestError(let message):
            return "Invalid request: \(message)"
        case .transportError:
            return "Transport error: Check your internet connection"
        case .invalidResponse:
            return "Invalid response"
        case .validationError(let reason):
            return "Validation Error: \(reason)"
        case .decodingError:
            return "The server returned data in an unexpected format. Try updating the app."
        case .serverError(let statusCode, let reason, let retryAfter):
            return "Server error with code \(statusCode), reason: \(reason ?? "no reason given"), retry after: \(retryAfter ?? "no retry after provided")"
        case .unauthorized:
            return "Token is expired!"
        case .someServerIssues:
            return "There is some unwanted issue, retry later please"
        }
    }
}

class NetworkManager {
        
    static func getData(url: URL, retry: Int = 2, backoff: Int = 3) -> AnyPublisher<Data,Error> {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 10
        configuration.waitsForConnectivity = true
        
        let session = URLSession(configuration: configuration)

        let dataTaskPublisher = session.dataTaskPublisher(for: url)
        // handle URL errors (most likely not able to connect to the server)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .mapError { error -> Error in
                return APIError.transportError
            }
        
        // handle all other errors
            .tryMap { (data, response) -> (data: Data, response: URLResponse) in
                print("Received response from server, now checking status code")
                
                guard let urlResponse = response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }
                print("📦📦📦📦 \(urlResponse.statusCode) Status code ")
                if (200..<300) ~= urlResponse.statusCode {
                    print("[✅] Success")
                }
                else {
                    //We will decode error according to server error model
                    let decoder = JSONDecoder()
                    let apiError = try decoder.decode(APIErrorMessage.self, from: data)
                    
                    if urlResponse.statusCode == 400 {
                        throw APIError.validationError(apiError.message)
                    }
                    
                    if urlResponse.statusCode == 401 {
                        print("[⛔️] \(APIError.unauthorized.errorDescription ?? "401")")
                        /*i don't want to show token issue to user because in our case
                         user is unable to do anything
                         */
                        throw APIError.someServerIssues
                    }
                    
                    if (500..<600) ~= urlResponse.statusCode {
                        let retryAfter = urlResponse.value(forHTTPHeaderField: "Retry-After")
                        throw APIError.serverError(statusCode: urlResponse.statusCode, reason: apiError.message, retryAfter: retryAfter)
                    }
                    
                }
                return (data, response)
            }
        
        return dataTaskPublisher
            .retry(retry, withBackoff: backoff) { error in
                if case APIError.serverError(_, _, _) = error {
                    return true
                }
                else {
                    return false
                }
            }
            .map(\.data)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
