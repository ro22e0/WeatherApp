//
//  LocationUseCaseTests.swift
//  WeatherAppTests
//
//  Created by Ronaël Bajazet on 14/10/2019.
//  Copyright © 2019 Ro42e0 Company. All rights reserved.
//

import XCTest
@testable import WeatherApp

class LocationUseCaseTests: XCTestCase {

  class LocationWorkerSuccessMock: LocationWorkerProtocol {
    var delegate: LocationWorkerDelegate?

    func startMonitoring() {
      delegate?.worker(didUpdateLocation: DataLocation(lat: 48.85341, long: 2.3488))
    }

    func stopMonitoring() {}
  }

  class LocationWorkerFailMock: LocationWorkerProtocol {
    var delegate: LocationWorkerDelegate?

    func startMonitoring() {
      delegate?.worker(didFailWithError: .authorizationDenied)
    }

    func stopMonitoring() {}
  }

  class LocationWorkerObserverMock {
    var location: Observable<(Location?, LocationError?)> = Observable((nil, nil))

    private(set) var hasLocation: Bool = false
    private(set) var hasError: Bool = false

    private let expectation: XCTestExpectation

    init(expectation: XCTestExpectation) {
      self.expectation = expectation

      location.subscribe(on: self) { new, old in
        self.hasError = new.1 != nil
        self.hasLocation = new.0 != nil
        self.expectation.fulfill()
      }
    }
  }

  func testLocationUseCase_whenLocationAvailable_shouldReturnCorrectLocation() {
    let expectation = self.expectation(description: "Should return correct Location")
    let worker = LocationWorkerSuccessMock()
    let sut = LocationUseCase(worker: worker)
    let observer = LocationWorkerObserverMock(expectation: expectation)

    sut.run(request: LocationRequest(observer.location))

    wait(for: [expectation], timeout: 1)
    XCTAssertFalse(observer.hasError)
    XCTAssertTrue(observer.hasLocation)
    XCTAssertEqual(observer.location.value.0?.latitude, 48.85341)
  }

  func testLocationUseCase_whenAuthorizationDenied_shouldReturnErrorLocation() {
    let expectation = self.expectation(description: "Should return correct Location")
    let worker = LocationWorkerFailMock()
    let sut = LocationUseCase(worker: worker)
    let observer = LocationWorkerObserverMock(expectation: expectation)

    sut.run(request: LocationRequest(observer.location))

    wait(for: [expectation], timeout: 1)
    XCTAssertFalse(observer.hasLocation)
    XCTAssertTrue(observer.hasError)
  }
}
