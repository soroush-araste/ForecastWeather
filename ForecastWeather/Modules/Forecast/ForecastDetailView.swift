//
//  ForecastDetailView.swift
//  ForecastWeather
//
//  Created by soroush amini araste on 7/1/22.
//

import SwiftUI

struct ForecastDetailView: View {
    
    let forecastViewModel: ForecastViewModel
    
    var body: some View {
        ZStack {
            List {
                ForEach(forecastViewModel.getForecastDetails().sorted(by: >), id:\.key) { key, value in
                    HStack(spacing: 0) {
                        Text("\(key.capitalized): ")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .frame(width: 120, alignment: .leading)
                        Text(value)
                            .font(.body)
                    }
                }
            }
            .listStyle(PlainListStyle())
            .padding()
            .navigationTitle("Detailed Forecast")
        }
    }
}

struct ForecastDetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        let forecastViewModel = ForecastViewModel(
            forecast: Daily(date: Date(), temp: Temp(day: 10, min: 10, max: 10,night: 22), humidity: 10, weather: [], clouds: 10, pop: 10,uvIndex: 10, feelsLike: FeelsLike(day: 10, night: 10, eve: 10, morn: 10), pressure: 22, windSpeed: 10, sunrise: Date(), sunset: Date(), moonrise: Date()),
            
            current: Current(dt: 10, sunrise: 10, sunset: 10, temp: 10, feelsLike: 10, pressure: 10, humidity: 10, dewPoint: 10, uvi: 10, clouds: 10, visibility: 10, windSpeed: 10, windDeg: 10, weather: []))
        ForecastDetailView(forecastViewModel: forecastViewModel)
            .environmentObject(ForecastListViewModel())
    }
}
