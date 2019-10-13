//
//  Converter.swift
//  WeatherApp
//
//  Created by Ronaël Bajazet on 13/10/2019.
//  Copyright © 2019 Ro42e0 Company. All rights reserved.
//

import Foundation

struct Converter {
  struct Degree {
    static func kelvinToCelsius(_ kelvin: Double) -> Double {
      return kelvin - 273.15
    }
  }
  struct Pressure {
    static func pascalToHpa(_ pascal: Int) -> Int {
      return pascal / 100
    }
  }
}
