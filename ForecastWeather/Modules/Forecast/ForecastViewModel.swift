//
//  ForecastViewModel.swift
//  ForecastWeather
//
//  Created by soroush amini araste on 6/30/22.
//

import Foundation
import SwiftUI

struct ForecastViewModel {
        
    let forecast: Daily
    let current: Current
  
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
        return Self.dateFormatter.string(from: forecast.date)
    }
    
    var overview: String {
        return forecast.weather[0].description.capitalized
    }
    
    var high: String {
        return "\(Self.numberFormatter.string(for: forecast.temp.max) ?? "-")°"
    }
    
    var low: String {
        return "\(Self.numberFormatter.string(for: forecast.temp.min) ?? "-")°"
    }
    
    var humidity: String {
        return "Humidity \(forecast.humidity)%"
    }
    
    var currentTemp: String {
        return "\(Self.numberFormatter.string(for: current.temp) ?? "-")°"
    }
    
    var eachDayTemp: String {
        return "\(Self.numberFormatter.string(for: forecast.temp.day) ?? "-")°"
    }
    
    var uvIndex: String {
        return "\(Self.numberFormatter.string(for: forecast.uvIndex) ?? "-")"
    }
    
    var feelsLike: String {
        return "\(Self.numberFormatter.string(for: forecast.feelsLike.day) ?? "-")"
    }
    
    var pressure: String {
        return "\(Self.numberFormatter.string(for: forecast.pressure) ?? "-")"
    }
    
    var windSpeed: String {
        return "\(Self.numberFormatter.string(for: forecast.windSpeed) ?? "-")"
    }
    
    var sunrise: String {
        return Self.dateFormatter2.string(from: forecast.sunrise)
    }
    
    var sunset: String {
        return Self.dateFormatter2.string(from: forecast.sunset)
    }
    
    var moonrise: String {
        return Self.dateFormatter2.string(from: forecast.moonrise)
    }
    
    func formattedTemp(temp: Double) -> String {
        return "\(Self.numberFormatter.string(for: temp) ?? "-")°"
    }
    
    var dailyIconURL: URL {
        let urlString = "https://openweathermap.org/img/wn/\(forecast.weather[0].icon)@2x.png"
        return URL(string: urlString)!
    }
    
    var currentIconURL: URL {
        let urlString = "https://openweathermap.org/img/wn/\(current.weather[0].icon)@2x.png"
        return URL(string: urlString)!
    }
    
    func getForecastDetails() -> [String: String] {
        let detailsDict: [String: String] = [
            "sunrise": sunrise,
            "sunset": sunset,
            "moonrise": moonrise,
            "uv Index": uvIndex,
            "feels Like": feelsLike,
            "humidity": "\(forecast.humidity)%",
            "pressure": pressure,
            "wind Speed": windSpeed,
            "max temperature": formattedTemp(temp: forecast.temp.max),
            "min temperature": formattedTemp(temp: forecast.temp.min),
            "day temperature": formattedTemp(temp: forecast.temp.day),
            "night temperature": formattedTemp(temp: forecast.temp.night)
        ]
        return detailsDict
    }
}
