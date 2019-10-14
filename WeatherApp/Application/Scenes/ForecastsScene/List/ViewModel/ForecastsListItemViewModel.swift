//
//  ForecastsListItemViewModel.swift
//  WeatherApp
//
//  Created by Ronaël Bajazet on 13/10/2019.
//  Copyright © 2019 Ro42e0 Company. All rights reserved.
//

import Foundation

protocol ForecastsListItemViewModelInput {}

protocol ForecastsListItemViewModelProtocol {
  var hour: String { get }
  var temperature: String { get }
  var humidity: String { get }
  var wind: String { get }
}

struct ForecastsListItemViewModel: ForecastsListItemViewModelProtocol {
  var hour: String
  var temperature: String
  var humidity: String
  var wind: String
}

protocol ForecastsListSectionViewModelProtocol {
  var title: String { get }
  var items: [ForecastsListItemViewModelProtocol] { get }
}

struct ForecastsListSectionViewModel: ForecastsListSectionViewModelProtocol {
  var title: String
  var items: [ForecastsListItemViewModelProtocol]
}
