//
//  DayForecastsUseCase.swift
//  WeatherApp
//
//  Created by Ronaël Bajazet on 13/10/2019.
//  Copyright © 2019 Ro42e0 Company. All rights reserved.
//

import Foundation

protocol DayForecastsUseCaseProtocol: UseCaseProtocol {
  func run(request: ForecastsRequest, completion: @escaping (Result<[DayForecasts], Error>) -> Void)
}

struct ForecastsRequest {
  let location: Location
}

class DayForecastsUseCase: DayForecastsUseCaseProtocol {
  private let repository: ForecastsRepositoryProtocol

  init(repository: ForecastsRepositoryProtocol) {
    self.repository = repository
  }

  func run(request: ForecastsRequest, completion: @escaping (Result<[DayForecasts], Error>) -> Void) {
    repository.forecastsList(location: request.location) { [weak self] result in
      guard let self = self else { return }
      switch result {

      case .success(let data):
        if data.state == 200 {
          self.repository.save(forecasts: data, completion: nil)
        }

        let allForecasts = data.forecasts.compactMap { $0.mapToEntity() }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        let groupedForecasts = allForecasts.groupBy(\.date) { value -> String in
          return formatter.string(from: value)
        }

        var days = [DayForecasts]()
        for (key, value) in groupedForecasts {
          guard let date = formatter.date(from: key) else { return }
          days.append(DayForecasts(date: date, forcasts: value.orderBy(\.date) { $0 < $1}))
        }

        completion(.success(days))

      case .failure(let error):
        // TODO: try get persisted data
        completion(.failure(error))
      }
    }
  }
}

private extension DataForecast {
  func mapToEntity() -> Forecast? {
    guard let date = date,
      let temperature = temperature,
      let pressure = pressure,
      let rain = rain,
      let snow = snow,
      let humidity = humidity,
      let avgWind = avgWind,
      let windGust = windGust,
      let windDirection = windDirection else {
        return nil
    }

    let snowBool = snow == "oui"
    let celsiusTemperature = Converter.Degree.kelvinToCelsius(temperature)
    let hPaPressure = Converter.Pressure.pascalToHpa(pressure)
    let wind = Forecast.Wind(average: avgWind, gust: windGust, direction: windDirection)

    return Forecast(
      date: date,
      temperature: Int(celsiusTemperature),
      pressure: hPaPressure,
      rain: Int(rain),
      snow: snowBool,
      humidity: humidity,
      wind: wind)
  }
}
