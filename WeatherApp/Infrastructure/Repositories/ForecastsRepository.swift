//
//  ForecastRepository.swift
//  WeatherApp
//
//  Created by Ronaël Bajazet on 13/10/2019.
//  Copyright © 2019 Ro42e0 Company. All rights reserved.
//

import Foundation

class ForecastsRepository: ForecastsRepositoryProtocol {

  private let service: NetworkServiceProvider

  init(service: NetworkServiceProvider) {
    self.service = service
  }

  func forecastsList(location: Location, completion: @escaping (Result<DataForecasts, Error>) -> Void) {
    let endpoint = Endpoints.forecasts(lat: location.latitude, long: location.longitude)
    service.request(with: endpoint, completion: completion)
  }

  func save(forecasts: DataForecasts, completion: ((Result<DataForecasts, Error>) -> Void)?) {}
}
