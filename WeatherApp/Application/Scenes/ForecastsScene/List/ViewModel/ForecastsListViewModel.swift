//
//  ForecastsListViewModel.swift
//  WeatherApp
//
//  Created by Ronaël Bajazet on 13/10/2019.
//  Copyright © 2019 Ro42e0 Company. All rights reserved.
//

import Foundation

protocol ForecastsListViewModelInput {
  func viewDidLoad()
  func didSelect(item: ForecastsListItemViewModelProtocol)
}

protocol ForecastsListViewModelOutput {
  var sections: Observable<[ForecastsListSectionViewModelProtocol]> { get }
  var error: Observable<String> { get }
  var numberOfSections: Int { get }
}

typealias ForecastsListViewModelProtocol =
  ForecastsListViewModelInput & ForecastsListViewModelOutput


class ForecastsListViewModel: ViewModel, ForecastsListViewModelProtocol {
  
  // MARK: - Output properties
  var sections: Observable<[ForecastsListSectionViewModelProtocol]> = Observable([ForecastsListSectionViewModelProtocol]())
  var error: Observable<String> = Observable(String())
  var numberOfSections: Int {
    return sections.value.count
  }
  
  private var location: Observable<(Location?, LocationError?)> = Observable((nil, nil))
  private var forecasts = [DayForecasts]()
  
  private let coordinator: Coordinator
  private let forecastsUseCase: DayForecastsUseCaseProtocol
  private let locationUseCase: LocationUseCaseProtocol
  
  init(coordinator: Coordinator,
       forecastsUseCase: DayForecastsUseCaseProtocol, locationUseCase: LocationUseCaseProtocol) {
    self.coordinator = coordinator
    self.forecastsUseCase = forecastsUseCase
    self.locationUseCase = locationUseCase
    bind()
  }
  
  private func bind() {
    location.subscribe(on: self) { [weak self] new, old in
      guard let self = self else { return }
      
      if let error = new.1 {
        self.handle(error: error)
      }
      if let location = new.0 {
        self.load(for: location)
      }
    }
  }
  
  private func userLocation() {
    self.locationUseCase.run(request: LocationRequest(location))
  }
  
  private func load(for location: Location) {
    //    Location(locality: "Paris", latitude: 48.85341, longitude: 2.3488)
    let request = ForecastsRequest(location: location)
    
    forecastsUseCase.run(request: request) { [weak self] result in
      guard let self = self else { return }
      
      switch result {
        
      case .success(let forecasts):
        let sections = forecasts.orderBy(\.date) {$0 < $1}
          .map { day -> ForecastsListSectionViewModel in
            let title = day.date.shortDayString
            let items = day.forcasts.map { f -> ForecastsListItemViewModel in
              let hour = f.date.string(for: "HH:mm")
              let temperature = "\(f.temperature)°C"
              let humidity = "\(f.humidity)%"
              let wind = "\(f.wind.gust) km/h"
              return ForecastsListItemViewModel(hour: hour,
                                                temperature: temperature,
                                                humidity: humidity,
                                                wind: wind)
            }
            
            return ForecastsListSectionViewModel(title: title, items: items)
        }
        self.sections.value = sections
        
      case .failure(let error):
        self.handle(error: error)
      }
    }
  }
  
  private func handle(error: Error) {}
}

// MARK: - Input (view events)
extension ForecastsListViewModel {
  
  func viewDidLoad() {
    userLocation()
  }
  
  func didSelect(item: ForecastsListItemViewModelProtocol) {
    // TODO: retrieve all item data
    
    coordinator.route(to: ForecastsListRoute.showForecastDetails(
      ForecastDetailsData(
        hour: item.hour,
        temperature: item.temperature,
        humidity: item.humidity,
        wind: item.wind)
    ))
  }
}
