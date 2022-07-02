//
//  ForecastWeatherApp.swift
//  ForecastWeather
//
//  Created by soroush amini araste on 6/30/22.
//

import SwiftUI

@main
struct ForecastWeatherApp: App {
    
    @StateObject private var viewModel = ForecastListViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(viewModel)
        }
    }
}
