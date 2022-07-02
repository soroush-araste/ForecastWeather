//
//  ForecastListViewModel.swift
//  ForecastWeather
//
//  Created by soroush amini araste on 6/30/22.
//

import Foundation
import Combine
import CoreLocation

class ForecastListViewModel: ObservableObject  {
    
    @Published var forecastViewModelItems: [ForecastViewModel] = []
    @Published var searchCityName: String = ""
    @Published var isLoading: Bool = true
    @Published var city: String = "Paris"
    
    var currentURL: URL?
    var anyCancellable = Set<AnyCancellable>()
    var dataService: ForecastDataService? = nil
    
    init() {
        let defaultURL = urlCreator()
        loadData(url: defaultURL)
        getCityWeather()
    }
    
    func urlCreator(lat: Double = 48.857191, lon: Double = 2.352902) -> URL {
        //Default location is Paris!
        let URLString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&exclude=minutely,hourly,alerts&units=metric&appid=db9e0317c0efaa1bcd7111d4c063cd2a"
        let url = URL(string: URLString)!
        currentURL = url
        return url
    }
    
    func loadData(url: URL) {
        isLoading = true
        dataService = ForecastDataService(url: url)
        dataService?.getForecast()
            .sink { [weak self] receiveCompletion in
                switch receiveCompletion{
                case .finished:
                    self?.isLoading = false
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] returnedItems in
                DispatchQueue.main.async {
                    self?.forecastViewModelItems = returnedItems.daily.map({ ForecastViewModel(forecast: $0, current: returnedItems.current )})
                }
            }
            .store(in: &anyCancellable)
    }
    
    func refreshData() {
        guard let url = currentURL else { return }
        loadData(url: url)
    }
    
    func getCityWeather() {
        $searchCityName
            .debounce(for: 1, scheduler: DispatchQueue.main)
            .sink { [weak self] name in
                guard let self = self else { return }
                self.getCityLocation(cityName: name) { lat, lon in
                    let url = self.urlCreator(lat: lat, lon: lon)
                    self.loadData(url: url)
                    print(name)
                    
                }
            }
            .store(in: &anyCancellable)
    }
    
    func getCityLocation(cityName: String, completion: @escaping (_ lat: Double, _ lon: Double)->() ) {
        guard !cityName.isEmpty else {
            return
        }
        CLGeocoder().geocodeAddressString(cityName) { [weak self] placeMark, error in
            if let _ = error {
                self?.city = "not found"
                return
            }
            self?.city = cityName
            if let lat = placeMark?.first?.location?.coordinate.latitude,
               let lon = placeMark?.first?.location?.coordinate.longitude {
                completion(lat,lon)
            }
        }
    }
}
