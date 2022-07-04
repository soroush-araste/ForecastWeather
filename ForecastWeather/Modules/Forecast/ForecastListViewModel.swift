//
//  ForecastListViewModel.swift
//  ForecastWeather
//
//  Created by soroush amini araste on 6/30/22.
//

import Foundation
import Combine
import CoreLocation
import SwiftUI

class ForecastListViewModel: ObservableObject  {
    
    @Published var forecastViewModelItems: [ForecastViewModel] = []
    @Published var searchCityName: String = ""
    @Published var isLoading: Bool = false
    @Published var city: String = "Paris"
    @Published var showError: Bool = false
    
    //@Published var bannerData: BannerModifier.BannerData = BannerModifier.BannerData(title: "", detail: "Notification text for the action you were trying to perform.", type: .Error)
    var errorMessage: String = ""
    var currentURL: URL?
    var anyCancellable = Set<AnyCancellable>()
    var dataService: ForecastRemoteDataService? = nil
    
    var repository: ForecastRepository? = nil
    
    init() {
        let defaultURL = urlCreator()
        getCityWeather()
        getDataFromRepository(url: defaultURL)
    }
    
    func urlCreator(lat: Double = 48.857191, lon: Double = 2.352902) -> URL {
        //Default location is Paris!
        let URLString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&exclude=minutely,hourly,alerts&units=metric&appid=db9e0317c0efaa1bcd7111d4c063cd2a"
        let url = URL(string: URLString)!
        currentURL = url
        return url
    }
    
    func getDataFromRepository(url: URL) {
        let dataService = ForecastRemoteDataService(url: url)
        repository = ForecastRepository(remoteDataSource: dataService)
        isLoading = true
        repository?.get()
            .sink(receiveCompletion: { [weak self] completion in
                switch completion{
                case .finished:
                    self?.isLoading = false
                case .failure(let error):
                    self?.isLoading = false
                    //uncomment this line to show a banner for erro
                    //self?.bannerData = BannerModifier.BannerData(title: "ERROR:", detail: error.localizedDescription, type: .Error)
                    self?.errorMessage = error.localizedDescription
                    self?.showError = true
                }
            },
            receiveValue: { [weak self] returnedItems in
                DispatchQueue.main.async {
                    self?.forecastViewModelItems = returnedItems.daily.map({ForecastViewModel(dailyForecast: $0, current: returnedItems.current)})
                }
            })
            .store(in: &anyCancellable)
    }
        
    func refreshData() {
        guard let url = currentURL else { return }
        getDataFromRepository(url: url)
    }
    
    func getCityWeather() {
        $searchCityName
            .debounce(for: 1, scheduler: DispatchQueue.main)
            .sink { [weak self] name in
                guard let self = self else { return }
                self.getCityLocation(cityName: name) { lat, lon in
                    let url = self.urlCreator(lat: lat, lon: lon)
                    self.getDataFromRepository(url: url)
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
