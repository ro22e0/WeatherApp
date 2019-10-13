//
//  ForecastsCoordinatorTests.swift
//  WeatherAppTests
//
//  Created by Ronaël Bajazet on 13/10/2019.
//  Copyright © 2019 Ro42e0 Company. All rights reserved.
//

import XCTest
@testable import WeatherApp

class ForecastsCoordinatorTests: XCTestCase {

  func test_whenInstanciateForecastsSceneCoordinator_thenShowForecastsList() {
    let sut = ForecastsSceneCoordinator()

    let isMainControllerNil = sut.mainController == nil

    XCTAssertTrue(isMainControllerNil, "Expected nil mainController")
  }
}
