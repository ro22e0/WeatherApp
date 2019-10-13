//
//  ForecastsListItemViewModel.swift
//  WeatherApp
//
//  Created by Ronaël Bajazet on 13/10/2019.
//  Copyright © 2019 Ro42e0 Company. All rights reserved.
//

import Foundation

protocol MoviesListItemViewModelInput {}

protocol MoviesListItemViewModelOutput {
  var hour: String { get }
  var temperature: String { get }
  var humidity: String { get }
  var wind: String { get }
}

typealias MoviesListItemViewModelProtocol =
  MoviesListItemViewModelOutput & MoviesListItemViewModelInput
