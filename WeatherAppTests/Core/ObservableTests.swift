//
//  ObservableTests.swift
//  WeatherAppTests
//
//  Created by Ronaël Bajazet on 12/10/2019.
//  Copyright © 2019 Ro42e0 Company. All rights reserved.
//

import XCTest

class ObservableTests: XCTestCase {

  private class ObserverMock {
    private(set) var newValue: String = ""

    func handle(new: String, old: String) {
      self.newValue = new
    }
  }

  func test_whenObervableValueChanged_thenNotifyObserver() {
    let observer = ObserverMock()
    let initialValue = "Toto"
    let expectedValue = "Tata"
    let sut = Observable<String>(initialValue)

    sut.subscribe(on: observer, with: observer.handle)
    sut.value = expectedValue

    XCTAssertEqual(observer.newValue, expectedValue, "Should be \(expectedValue)")
  }
}
