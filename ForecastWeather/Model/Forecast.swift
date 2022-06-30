//
//  Forecast.swift
//  ForecastWeather
//
//  Created by soroush amini araste on 6/30/22.
//

import Foundation

struct Forecast: Codable {
    let daily: [Daily]
}

struct Daily: Codable {
    let date: Date
    let temp: Temp
    let humidity: Int
    let weather: [Weather]
    let clouds: Int
    let pop: Double
    
    enum CodingKeys: String, CodingKey, Codable {
        case date = "dt"
        case temp, humidity, weather, clouds, pop
    }
}

struct Temp: Codable {
    let min: Double
    let max: Double
}

struct Weather: Codable {
    let id: Int
    let description: String
    let icon: String
}
