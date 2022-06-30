//
//  ForecastListViewModel.swift
//  ForecastWeather
//
//  Created by soroush amini araste on 6/30/22.
//

import Foundation
import Combine

class ForecastListViewModel: ObservableObject  {
    
    @Published var forecastsViewModels: [ForecastViewModel] = []
    
    var anyCancellable = Set<AnyCancellable>()
    
    private let dataService: ForecastDataService
    
    init(dataService: ForecastDataService)  {
        self.dataService = dataService
        loadData()
    }
    
    func loadData() {
        dataService.getForecast()
            .sink { receiveCompletion in
                switch receiveCompletion{
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] returnedItems in
                DispatchQueue.main.async {
                    self?.forecastsViewModels = returnedItems.daily.map({ ForecastViewModel(forecast: $0 )})
                    print(returnedItems)
                }
            }
            .store(in: &anyCancellable)
    }
}
