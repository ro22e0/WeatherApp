//
//  Forecast.swift
//  WeatherApp
//
//  Created by Ronaël Bajazet on 13/10/2019.
//  Copyright © 2019 Ro42e0 Company. All rights reserved.
//

import Foundation

struct Forecast {
  struct Wind {
    let average: Double // km/h
    let gust: Double // km/h
    let direction: Int // ° degrees
  }

  let date: Date
  let temperature: Int // kelvin
  let pressure: Int // pascal
  let rain: Int // mm
  let snow: Bool // non / oui
  let humidity: Double // %
  let wind: Wind // km/h
}
