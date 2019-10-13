//
//  Double+Format.swift
//  WeatherApp
//
//  Created by Ronaël Bajazet on 13/10/2019.
//  Copyright © 2019 Ro42e0 Company. All rights reserved.
//

import Foundation

extension Double {
  func rounded(place: Int) -> String {
    return String(format: "%.\(place)f", self)
  }
}
