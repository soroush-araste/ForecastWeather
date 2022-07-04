//
//  NetworkingManager.swift
//  ForecastWeather
//
//  Created by soroush amini araste on 7/3/22.
//

import Foundation
import Combine

class NetworkingManager {
    
    enum NetworkingError: LocalizedError {
        case badURLResponse(url: URL)
        case badRequest(statusCode: Int) //400
        case unauthorized(statusCode: Int) //401
        case paymentRequired(statusCode: Int) //402
        case forbidden(statusCode: Int) //403
        case notFound(statusCode: Int) //404
        case internalServerError(statusCode: Int) //500
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse(url: let url):
                return "[⛔️] Bad url response for this url: \(url)"
            case .badRequest(statusCode: let code):
                return "[⛔️] Response error code: \(code) Bad request"
            case .unauthorized(statusCode: let code):
                return "[⛔️] Response error code: \(code) Unauthorized"
            case .paymentRequired(statusCode: let code):
                return "[⛔️] Response error code: \(code) Payment Required"
            case .forbidden(statusCode: let code):
                return "[⛔️] Response error code: \(code) Forbidden access"
            case .notFound(statusCode: let code):
                return "[⛔️] Response error code: \(code) Not Found"
            case .internalServerError(statusCode: let code):
                return "[⛔️] Response error code: \(code) Internal Server Error"
            default:
                return "[⛔️] Unknown error occurred"
            }
        }
    }
    
    static func getData(url: URL) -> AnyPublisher<Data,Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { try handleURLResponse(output: $0, url: url)}
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse else {
            throw NetworkingError.badURLResponse(url: url)
        }
        let statusCode = response.statusCode
        switch statusCode {
        case 200:
            print("[✅] Success")
            return output.data
        case 400:
            throw NetworkingError.badRequest(statusCode: statusCode)
        case 401:
            throw NetworkingError.unauthorized(statusCode: statusCode)
        case 402:
            throw NetworkingError.paymentRequired(statusCode: statusCode)
        case 403:
            throw NetworkingError.forbidden(statusCode: statusCode)
        case 404:
            throw NetworkingError.notFound(statusCode: statusCode)
        case 500:
            throw NetworkingError.internalServerError(statusCode: statusCode)
        default:
            throw NetworkingError.unknown
        }
    }
    
//    static func handleCompletion(completion: Subscribers.Completion<Error>) {
//        switch completion {
//        case .finished:
//            break
//        case .failure(let error):
//            print(error.localizedDescription)
//        }
//    }
}
