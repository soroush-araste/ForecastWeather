//
//  ForecastViewModel.swift
//  ForecastWeather
//
//  Created by soroush amini araste on 6/30/22.
//

import Foundation
import SwiftUI

struct ForecastViewModel {
        
    let dailyForecast: DomainDaily
    let current: DomainCurrent
  
    private static var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter
    }
    
    private static var dateFormatter2: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter
    }
        
    private static var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 0
        return numberFormatter
    }
    
    private static var popNumberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        return numberFormatter
    }
    
    var day: String {
        return Self.dateFormatter.string(from: dailyForecast.date)
    }
    
    var overview: String {
        return dailyForecast.weather[0].description.capitalized
    }
    
    var high: String {
        return "\(Self.numberFormatter.string(for: dailyForecast.temp.max) ?? "-")°"
    }
    
    var low: String {
        return "\(Self.numberFormatter.string(for: dailyForecast.temp.min) ?? "-")°"
    }
    
    var humidity: String {
        return "Humidity \(dailyForecast.humidity)%"
    }
    
    var currentTemp: String {
        return "\(Self.numberFormatter.string(for: current.temp) ?? "-")°"
    }
    
    var eachDayTemp: String {
        return "\(Self.numberFormatter.string(for: dailyForecast.temp.day) ?? "-")°"
    }
    
    var uvIndex: String {
        return "\(Self.numberFormatter.string(for: dailyForecast.uvIndex) ?? "-")"
    }
    
    var feelsLike: String {
        return "\(Self.numberFormatter.string(for: dailyForecast.feelsLike.day) ?? "-")"
    }
    
    var pressure: String {
        return "\(Self.numberFormatter.string(for: dailyForecast.pressure) ?? "-")"
    }
    
    var windSpeed: String {
        return "\(Self.numberFormatter.string(for: dailyForecast.windSpeed) ?? "-")"
    }
    
    var sunrise: String {
        return Self.dateFormatter2.string(from: dailyForecast.sunrise)
    }
    
    var sunset: String {
        return Self.dateFormatter2.string(from: dailyForecast.sunset)
    }
    
    var moonrise: String {
        return Self.dateFormatter2.string(from: dailyForecast.moonrise)
    }
    
    func formattedTemp(temp: Double) -> String {
        return "\(Self.numberFormatter.string(for: temp) ?? "-")°"
    }
    
    var dailyIconURL: URL {
        let urlString = "https://openweathermap.org/img/wn/\(dailyForecast.weather[0].icon)@2x.png"
        return URL(string: urlString)!
    }
    
    var currentIconURL: URL {
        let urlString = "https://openweathermap.org/img/wn/\(current.weather[0].icon)@2x.png"
        return URL(string: urlString)!
    }
    
    var dailyIconName: String {
        return symbolIcon(icon: dailyForecast.weather[0].icon).symbol
    }
    
    var currentIconName: String {
        return symbolIcon(icon: current.weather[0].icon).symbol
    }
    
    func symbolIcon(icon: String) -> WeatherIconModel {
        switch icon {
        case "01d":
            return .clearSkyDay
        case "01n":
            return .clearSkyNight
        case "02d":
            return .fewCloudsDay
        case "02n":
            return .fewCloudsNight
        case "03d", "03n":
            return .scatteredClouds
        case "04d", "04n":
            return .brokenClouds
        case "09d", "09n":
            return .showerRain
        case "10d", "10n":
            return .rain
        case "11d", "11n":
            return .thunderstorm
        case "13d", "13n":
            return .snow
        case "50d", "50n":
            return .mist
        default:
            return .unknown
        }
    }
    
    
    
    func getForecastDetails() -> [String: String] {
        let detailsDict: [String: String] = [
            "sunrise": sunrise,
            "sunset": sunset,
            "moonrise": moonrise,
            "uv Index": uvIndex,
            "feels Like": feelsLike,
            "humidity": "\(dailyForecast.humidity)%",
            "pressure": pressure,
            "wind Speed": windSpeed,
            "max temperature": formattedTemp(temp: dailyForecast.temp.max),
            "min temperature": formattedTemp(temp: dailyForecast.temp.min),
            "day temperature": formattedTemp(temp: dailyForecast.temp.day),
            "night temperature": formattedTemp(temp: dailyForecast.temp.night)
        ]
        return detailsDict
    }
}
