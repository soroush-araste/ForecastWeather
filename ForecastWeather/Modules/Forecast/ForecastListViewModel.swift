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
    @Published var showBanner: Bool = false
    
    @Published var bannerData: BannerModifier.BannerData = BannerModifier.BannerData(title: "", detail: "", type: .Error)
    
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
    
    func urlCreator(lat: Double = Constants.DefaultLocation.lat, lon: Double = Constants.DefaultLocation.lon) -> URL {
        //Default location is Paris!
        var urlComponents = Constants.getBaseURLComponents()
        let queryItemLat = URLQueryItem(name: "lat", value: "\(lat)")
        let queryItemLon = URLQueryItem(name: "lon", value: "\(lon)")
        urlComponents.queryItems?.append(contentsOf: [queryItemLat, queryItemLon])
        currentURL = urlComponents.url
        return urlComponents.url!
    }
    
    func getDataFromRepository(url: URL) {
        let dataService = ForecastRemoteDataService(url: url)
        repository = ForecastRepository(remoteDataSource: dataService)
        isLoading = true
        repository?.get()
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion{
                case .finished:
                    self?.showError = false
                case .failure(let error):
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
        showError = false
        getDataFromRepository(url: url)
    }
    
    func getCityWeather() {
        $searchCityName
            .debounce(for: 0.6, scheduler: DispatchQueue.main)
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
                self?.bannerData = BannerModifier.BannerData(title: "not found".capitalized, detail: "The city you were looking for not found!", type: .Error)
                self?.showBanner = true
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
