//
//  WeatherIcons.swift
//  ForecastWeather
//
//  Created by soroush amini araste on 7/11/22.
//

import Foundation

enum WeatherIconModel: String {
    //Clear Day
    case clearSkyDay
    case clearSkyNight
    
    //Clear Night
    case fewCloudsDay
    case fewCloudsNight
    
    case scatteredClouds
    case brokenClouds
    case showerRain
    case rain
    case thunderstorm
    case snow
    case mist
    
    case unknown
    
    var symbol: String {
        switch self {
        case .clearSkyDay:
            return "sun.max.fill"
        case .clearSkyNight:
            return "moon.fill"
        case .fewCloudsDay:
            return "cloud.sun.fill"
        case .fewCloudsNight:
            return "cloud.moon.fill"
        case .scatteredClouds:
            return "cloud.fill"
        case .brokenClouds:
            return "smoke.fill"
        case .showerRain:
            return "cloud.heavyrain.fill"
        case .rain:
            return "cloud.rain.fill"
        case .thunderstorm:
            return "cloud.bolt.rain.fill"
        case .snow:
            return "snowflake"
        case .mist:
            return "cloud.fog.fill"
        case .unknown:
            return "questionmark.circle.fill"
        }
    }
}
