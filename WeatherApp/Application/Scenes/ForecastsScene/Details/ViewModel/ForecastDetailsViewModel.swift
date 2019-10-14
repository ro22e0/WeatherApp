//
//  ForecastDetailsViewModel.swift
//  WeatherApp
//
//  Created by Ronaël Bajazet on 14/10/2019.
//  Copyright © 2019 Ro42e0 Company. All rights reserved.
//

import Foundation

protocol ForecastDetailsViewModelInput {}

protocol ForecastDetailsViewModelOutput {
  var hour: Observable<String> { get }
  var temperature: Observable<String> { get }
  var humidity: Observable<String> { get }
  var wind: Observable<String> { get }
}

typealias ForecastDetailsViewModelProtocol =
  ForecastDetailsViewModelInput & ForecastDetailsViewModelOutput

struct ForecastDetailsData {
  var hour: String
  var temperature: String
  var humidity: String
  var wind: String
}

class ForecastDetailsViewModel: ViewModel, ForecastDetailsViewModelProtocol {

  // MARK: - Output properties
  var hour: Observable<String>
  var temperature: Observable<String>
  var humidity: Observable<String>
  var wind: Observable<String>

  init(details: ForecastDetailsData) {
    hour = Observable<String>(details.hour)
    temperature = Observable<String>(details.temperature)
    humidity = Observable<String>(details.humidity)
    wind = Observable<String>(details.wind)
  }
}
