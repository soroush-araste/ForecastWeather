//
//  ForecastDataService.swift
//  ForecastWeather
//
//  Created by soroush amini araste on 6/30/22.
//

import Foundation
import Combine

protocol ForecastDataProtocol {
    func getForecast() -> AnyPublisher<Forecast,Error>
}

class ForecastDataService: ForecastDataProtocol {
    
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
        URLSession.shared.dataTaskPublisher(for: url)
            .map({$0.data})
            .decode(type: Forecast.self, decoder: jsonDecoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
