//
//  Constants.swift
//  ForecastWeather
//
//  Created by soroush amini araste on 7/5/22.
//

import Foundation

struct Constants {
    
    static let appID = "db9e0317c0efaa1bcd7111d4c063cd2a"
    
    static func getBaseURLComponents() -> URLComponents {
        var urlComponents = URLComponents()
        urlComponents.host = "api.openweathermap.org"
        urlComponents.scheme = "https"
        urlComponents.path = "/data/2.5/onecall"
        let queryItemToken = URLQueryItem(name: "appid", value: appID)
        let queryItemExclude = URLQueryItem(name: "exclude", value: "minutely,hourly,alerts")
        let queryItemUnits = URLQueryItem(name: "units", value: "metric")
        urlComponents.queryItems =  [queryItemExclude, queryItemUnits, queryItemToken]
        return urlComponents
    }
    
    struct DefaultLocation {
        static let name: String = "Paris"
        static let lat: Double = 48.857191
        static let lon: Double = 2.352902
    }
}
