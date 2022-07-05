//
//  DomainForecast.swift
//  ForecastWeather
//
//  Created by soroush amini araste on 7/5/22.
//

import Foundation

struct DomainForecast {
    let daily: [DomainDaily]
    let current: DomainCurrent
}

struct DomainDaily {
    let date: Date
    let temp: DomainTemp
    let humidity: Int
    let weather: [DomainWeather]
    let uvIndex: Double
    let feelsLike: DomainFeelsLike
    let pressure: Int
    let windSpeed: Double
    let sunrise: Date
    let sunset: Date
    let moonrise: Date
}

struct DomainCurrent {
    let temp: Double
    let weather: [DomainWeather]
}

struct DomainFeelsLike {
    let day: Double
    let night: Double
    let eve: Double
    let morn: Double
}

struct DomainTemp {
    let day: Double
    let min: Double
    let max: Double
    let night: Double
}

struct DomainWeather {
    let id: Int
    let description: String
    let icon: String
}
