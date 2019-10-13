//
//  DayForecastsUseCaseTests.swift
//  WeatherAppTests
//
//  Created by Ronaël Bajazet on 13/10/2019.
//  Copyright © 2019 Ro42e0 Company. All rights reserved.
//

import XCTest
@testable import WeatherApp

class DayForecastsUseCaseTests: XCTestCase {

  class NetworkSuccessMock: NetworkProvider {
    required init(sessionable: NetworkSessionable) {}

    func request(requestable: Requestable, completion: @escaping NetworkCompletion) {
      completion(.success(json))
    }
  }

  class NetworkFailMock: NetworkProvider {
    required init(sessionable: NetworkSessionable) {}

    func request(requestable: Requestable, completion: @escaping NetworkCompletion) {
      completion(.failure(.notConnected))
    }
  }

  func testForecastsUseCase_whenSuccessFetchRequest_thenGetDayForecasts() {
    let expectation = self.expectation(description: "DayForecast fetched")

    let configuration = NetworkConfiguration(baseURL: "")
    let session = AlamofireSession(configurable: configuration)
    let network = NetworkSuccessMock(sessionable: session)
    let service = NetworkService(provider: network)
    let repository = ForecastsRepository(service: service)
    let sut = DayForecastsUseCase(repository: repository)

    let request = ForecastsRequest(location:
      Location(locality: "Paris", latitude: 48.85341, longitude: 2.3488))

    sut.run(request: request, completion: { result in
      if let _ = try? result.get() {
        expectation.fulfill()
      }
    })

    wait(for: [expectation], timeout: 5)
  }

  func testForecastsUseCase_whenNetworkDown_thenGetPersistedDayForecasts() {
    let expectation = self.expectation(description: "DayForecast fetched")
    expectation.expectedFulfillmentCount = 2

    let configuration = NetworkConfiguration(baseURL: "")
    let session = AlamofireSession(configurable: configuration)
    let successNetwork = NetworkSuccessMock(sessionable: session)
    let service = NetworkService(provider: successNetwork)
    let repository = ForecastsRepository(service: service)
    let useCase = DayForecastsUseCase(repository: repository)

    let request = ForecastsRequest(location:
      Location(locality: "Paris", latitude: 48.85341, longitude: 2.3488))

    useCase.run(request: request, completion: { result in
      expectation.fulfill()
    })

    let failNetwork = NetworkFailMock(sessionable: session)
    let failService = NetworkService(provider: failNetwork)
    let persistRepository = ForecastsRepository(service: failService)
    let sut = DayForecastsUseCase(repository: persistRepository)

    var forecasts = [DayForecasts]()

    sut.run(request: request, completion: { result in
      do {
        forecasts = try result.get()
        expectation.fulfill()
      }
      catch {
        XCTFail("Should not pass here")
      }
    })

    wait(for: [expectation], timeout: 5)
    XCTAssertEqual(forecasts.count, 9)
  }
}
