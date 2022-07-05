//
//  ForecastDataService.swift
//  ForecastWeather
//
//  Created by soroush amini araste on 6/30/22.
//

import Foundation
import Combine

protocol ForecastDataSource {
    func getForecast() -> AnyPublisher<Forecast,Error>
}

class ForecastRemoteDataService: ForecastDataSource {
    
    private var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }
    
    private let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func getForecast() -> AnyPublisher<Forecast,Error> {
        let decoder = jsonDecoder
        return NetworkManager.getData(url: url)
            .tryMap { data in
                do {
                    return try decoder.decode(Forecast.self, from: data)
                }
                catch {
                    throw APIError.decodingError(error)
                }
            }
            .eraseToAnyPublisher()
    }
}
