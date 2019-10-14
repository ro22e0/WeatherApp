//
//  ForecastDetailsViewModel.swift
//  WeatherApp
//
//  Created by Ronaël Bajazet on 14/10/2019.
//  Copyright © 2019 Ro42e0 Company. All rights reserved.
//

import Foundation

protocol ForecastDetailsViewModelInput {}

protocol ForecastDetailsViewModelOutput {}

typealias ForecastDetailsViewModelProtocol =
  ForecastDetailsViewModelInput & ForecastDetailsViewModelOutput

struct ForecastDetailsData {
  var hour: String
  var temperature: String
  var humidity: String
  var wind: String
}

class ForecastDetailsViewModel: ViewModel, ForecastDetailsViewModelProtocol {

  private let details: ForecastDetailsData

  init(details: ForecastDetailsData) {
    self.details = details
  }
}
