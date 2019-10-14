//
//  Date+Format.swift
//  WeatherApp
//
//  Created by Ronaël Bajazet on 14/10/2019.
//  Copyright © 2019 Ro42e0 Company. All rights reserved.
//

import Foundation

extension Date {
  func string(for format: String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = format
    return formatter.string(from: self)
  }
  
  var shortDayString: String {
    let formatter = DateFormatter()
    formatter.setLocalizedDateFormatFromTemplate("EEEEd")
    return formatter.string(from: self)
  }
}
