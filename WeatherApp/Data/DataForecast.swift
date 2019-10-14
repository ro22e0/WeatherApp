//
//  DataForecast.swift
//  WeatherApp
//
//  Created by Ronaël Bajazet on 13/10/2019.
//  Copyright © 2019 Ro42e0 Company. All rights reserved.
//

import Foundation

struct DataForecasts {
  let state: Int
  var forecasts: [DataForecast]
}

extension DataForecasts: Decodable {

  enum CodingKeys: String, CodingKey {
    case state = "request_state"
  }

  struct UnknownCodingKey: CodingKey {
    var stringValue: String
    init?(stringValue: String) {
      self.stringValue = stringValue
    }

    var intValue: Int?
    init?(intValue: Int) {
      return nil
    }
  }

  var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    formatter.calendar = Calendar(identifier: .gregorian)
    return formatter
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    state = try values.decode(Int.self, forKey: .state)

    forecasts = []
    let otherValues = try decoder.container(keyedBy: UnknownCodingKey.self)
    try otherValues.allKeys.forEach { key in
      if let date = key.stringValue.date(for: "yyyy-MM-dd HH:mm:ss") {
        var fc = try otherValues.decode(DataForecast.self, forKey: key)
        fc.date = date
        forecasts.append(fc)
      }
    }
  }
}

struct DataForecast {
  var date: Date? // datetime
  var temperature: Double? // kelvin
  var pressure: Int? // pascal
  var rain: Double? // mm
  var humidity: Double? // %
  var avgWind: Double? // km/h
  var windGust: Double? // km/h
  var windDirection: Int? // ° degrees
  var snow: String? // non / oui
}

extension DataForecast: Decodable {

  enum CodingKeys: String, CodingKey {
    case temperature = "temperature"
    case pressure = "pression"
    case rain = "pluie"
    case snow = "risque_neige"
    case humidity = "humidite"
    case avgWind = "vent_moyen"
    case windGust = "vent_rafales"
    case windDirection = "vent_direction"
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    temperature = try values.decodeIfPresent([String: Double].self, forKey: .temperature)?["2m"]
    pressure = try values.decodeIfPresent([String: Int].self, forKey: .pressure)?["niveau_de_la_mer"]
    rain = try values.decodeIfPresent(Double.self, forKey: .rain)
    humidity = try values.decodeIfPresent([String: Double].self, forKey: .humidity)?["2m"]
    avgWind = try values.decodeIfPresent([String: Double].self, forKey: .avgWind)?["10m"]
    windGust = try values.decodeIfPresent([String: Double].self, forKey: .windGust)?["10m"]
    windDirection = try values.decodeIfPresent([String: Int].self, forKey: .windDirection)?["10m"]
    snow = try values.decodeIfPresent(String.self, forKey: .snow)
  }
}
