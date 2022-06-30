//
//  ForecastWeatherApp.swift
//  ForecastWeather
//
//  Created by soroush amini araste on 6/30/22.
//

import SwiftUI

@main
struct ForecastWeatherApp: App {
    
    let dataService = ForecastDataService(url: URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=36.32277&lon=59.53649&exclude=current,minutly,hourly,alerts&appid=db9e0317c0efaa1bcd7111d4c063cd2a")!)
    
    var body: some Scene {
        WindowGroup {
            ContentView(dataService: dataService)
        }
    }
}
