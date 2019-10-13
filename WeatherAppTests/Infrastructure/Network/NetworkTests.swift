//
//  NetworkTests.swift
//  WeatherAppTests
//
//  Created by Ronaël Bajazet on 13/10/2019.
//  Copyright © 2019 Ro42e0 Company. All rights reserved.
//

import XCTest
@testable import WeatherApp

class NetworkTests: XCTestCase {

  class EndpointMock: Requestable {
    let resource: String
    let method: HttpMethod = .get
    let parameters: Parameters = [:]
    let encoding: Encoding = .url

    init(resource: String) {
      self.resource = resource
    }
  }

  class NetworkConfigurableMock: NetworkConfigurable {
    let baseURL: String = "http://www.mocky.io/v2/" // 5da30a2a2f000059008a06c7
    let timeout: TimeInterval = 10
    var headers: [String: String] = [:]
  }

  class NetworkRequestMock: NetworkRequest {
    var data: Data?

    init(expectedData: Data?) {
      data = expectedData
    }

    func execute(completion: @escaping RequestCompletion) {
      guard let d = data else {
        completion(.failure(NSError(domain: "", code: NSURLErrorTimedOut)))
        return
      }
      completion(.success(d))
    }

    func cancel() {}
  }

  class NetworkSessionableMock: NetworkSessionable {
    var configuration: NetworkConfigurable
    var expectedData: Data?

    required init(configurable: NetworkConfigurable) {
      configuration = configurable
    }

    convenience init(configurable: NetworkConfigurable, data: Data) {
      self.init(configurable: configurable)
      expectedData = data
    }

    func request(from requestable: Requestable) throws -> NetworkRequest {
      return NetworkRequestMock(expectedData: expectedData)
    }
  }

  func test_whenMockDataPassed_shouldReturnResponse() {
    let expectedData = "{\"message\": \"Bonjour\"}".data(using: .utf8)!

    let config = NetworkConfigurableMock()
    let session = NetworkSessionableMock(configurable: config, data: expectedData)

    let expectation = self.expectation(description: "Should return correct data")

    let sut = Network(sessionable: session)

    sut.request(requestable: EndpointMock(resource: "/hello")) { result in

      guard let resultData = try? result.get() else {
        XCTFail("Should return proper response")
        return
      }

      XCTAssertEqual(resultData, expectedData)
      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 0.1)
  }

  func test_whenNetworkSlow_shouldReturnTimeoutError() {
    let config = NetworkConfigurableMock()
    let session = NetworkSessionableMock(configurable: config)

    let expectation = self.expectation(description: "Should return correct error")

    let sut = Network(sessionable: session)

    sut.request(requestable: EndpointMock(resource: "/hello")) { result in

      do {
        _ = try result.get()
        XCTFail("Should not pass here")
      }
      catch let error {
        guard case NetworkError.timedOut = error else {
          XCTFail("Incorrect Error handled")
          return
        }
        expectation.fulfill()
      }
    }

    wait(for: [expectation], timeout: 0.1)
  }
}
