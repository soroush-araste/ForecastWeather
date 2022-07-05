//
//  ForecastRepository.swift
//  ForecastWeather
//
//  Created by soroush amini araste on 7/3/22.
//

import Foundation
import Combine

protocol Repository {
    associatedtype T
    
    func get() -> AnyPublisher<T, Error>
}

struct ForecastRepository: Repository {
    
    typealias T = DomainForecast
    
    private let remoteDataSource: ForecastDataSource
    
    init(remoteDataSource: ForecastDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    func get() -> AnyPublisher<DomainForecast, Error> {
        return remoteDataSource.getForecast()
            .map({ createDomainForecast(forecast: $0) })
            .eraseToAnyPublisher()
    }
    
    private func createDomainForecast(forecast: Forecast) -> DomainForecast {
        var domainDaily: [DomainDaily] = []
        for daily in forecast.daily {
            let dailyTemp = DomainTemp(day: daily.temp.day, min: daily.temp.min, max: daily.temp.max, night: daily.temp.night)
            let dailyFeelsLike = DomainFeelsLike(day: daily.feelsLike.day, night: daily.feelsLike.night, eve: daily.feelsLike.eve, morn: daily.feelsLike.morn)
            
            let weather = createDomainWeather(weathers: daily.weather)
            domainDaily.append(DomainDaily(date: daily.date, temp: dailyTemp, humidity: daily.humidity, weather: weather, uvIndex: daily.uvIndex, feelsLike: dailyFeelsLike, pressure: daily.pressure, windSpeed: daily.windSpeed, sunrise: daily.sunrise, sunset: daily.sunset, moonrise: daily.moonrise))
        }
        
        let domainWeather = createDomainWeather(weathers: forecast.current.weather)
        let domainCurrent = DomainCurrent(temp: forecast.current.temp, weather: domainWeather)
        return DomainForecast(daily: domainDaily, current: domainCurrent)
    }
    
    private func createDomainWeather(weathers: [Weather]) -> [DomainWeather] {
        var domainWeathers: [DomainWeather] = []
        for item in weathers {
            let dailyWeather = DomainWeather(id: item.id, description: item.description, icon: item.icon)
            domainWeathers.append(dailyWeather)
        }
        return domainWeathers
    }
}
