//
//  Forecast.swift
//  ForecastWeather
//
//  Created by soroush amini araste on 6/30/22.
//

import Foundation

struct Forecast: Codable {
    let daily: [Daily]
    let current: Current
}

struct Current: Codable {
    let dt, sunrise, sunset: Int
    let temp, feelsLike: Double
    let pressure, humidity: Int
    let dewPoint, uvi: Double
    let clouds, visibility: Int
    let windSpeed: Double
    let windDeg: Int
    let weather: [Weather]

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case uvi, clouds, visibility
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather
    }
}

struct Daily: Codable {
    let date: Date
    let temp: Temp
    let humidity: Int
    let weather: [Weather]
    let clouds: Int
    let pop: Double
    let uvIndex: Double
    let feelsLike: FeelsLike
    let pressure: Int
    let windSpeed: Double
    let sunrise: Date
    let sunset: Date
    let moonrise: Date
    
    enum CodingKeys: String, CodingKey, Codable {
        case date = "dt"
        case uvIndex = "uvi"
        case feelsLike = "feels_like"
        case windSpeed = "wind_speed"
        case temp, humidity, weather, clouds, pop, pressure,sunrise, sunset, moonrise
    }
}

struct FeelsLike: Codable {
    let day: Double
    let night: Double
    let eve: Double
    let morn: Double
}

struct Temp: Codable {
    let day: Double
    let min: Double
    let max: Double
    let night: Double
}

struct Weather: Codable {
    let id: Int
    let description: String
    let icon: String
}
