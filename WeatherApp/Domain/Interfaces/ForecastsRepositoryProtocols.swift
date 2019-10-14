//
//  ForecastsRepositoryProtocols.swift
//  WeatherApp
//
//  Created by Ronaël Bajazet on 13/10/2019.
//  Copyright © 2019 Ro42e0 Company. All rights reserved.
//

import Foundation

protocol ForecastsRepositoryProtocol: RepositoryProtocol, ForecastsServiceRepositoryProtocol & ForecastsPersistentRepositoryProtocol {}

protocol ForecastsServiceRepositoryProtocol {
  func forecastsList(location: Location, completion: @escaping (Result<DataForecasts, Error>) -> Void)
}

protocol ForecastsPersistentRepositoryProtocol {
  func save(forecasts: DataForecasts, completion: ((Result<DataForecasts, Error>) -> Void)?)
}
