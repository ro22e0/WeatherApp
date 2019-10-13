//
//  ForecastServiceTests.swift
//  WeatherAppTests
//
//  Created by Ronaël Bajazet on 13/10/2019.
//  Copyright © 2019 Ro42e0 Company. All rights reserved.
//

import XCTest
@testable import WeatherApp

class ForecastServiceTests: XCTestCase {

  private class EndpointMock<T>: GenericEndpoint<T> {
    init(resource: String) {
      super.init(resource: resource, method: .get, parameters: [:], encoding: .url)
    }
  }

  class NetworkConfigurableMock: NetworkConfigurable {
    let baseURL: String // 5da30a2a2f000059008a06c7
    let timeout: TimeInterval = 10
    let headers: [String: String] = [:]

    init(baseURL: String = "http://www.mocky.io/v2/") {
      self.baseURL = baseURL
    }
  }


  class NetworkRequestMock: NetworkRequest {
    private var data: Data?
    private var error: Error?

    init(data: Data?, error: Error?) {
      self.data = data
      self.error = error
    }

    func execute(completion: @escaping RequestCompletion) {
      if let error = self.error {
        completion(.failure(error))
        return
      }
      completion(.success(data as Any))
    }

    func cancel() {}
  }

  class NetworkSessionableMock: NetworkSessionable {
    var configuration: NetworkConfigurable
    private var expectedData: Data?
    private var expectedError: Error?

    required init(configurable: NetworkConfigurable) {
      configuration = configurable
    }

    convenience init(configurable: NetworkConfigurable, data: Data? = nil, error: Error? = nil) {
      self.init(configurable: configurable)
      expectedData = data
      expectedError = error

    }

    func request(from requestable: Requestable) throws -> NetworkRequest {
      return NetworkRequestMock(data: expectedData, error: expectedError)
    }
  }

  struct Hello: Decodable {
    var message: String
  }

  

  func test_whenValidJson_shouldDecodeResponse() {
    let expectedData = "{\"message\": \"Bonjour\"}".data(using: .utf8)!

    let config = NetworkConfigurableMock()
    let session = NetworkSessionableMock(configurable: config, data: expectedData)
    let network = Network(sessionable: session)

    let sut = NetworkService(provider: network)

    let expectation = self.expectation(description: "Should return correct object")

    let endpoint = EndpointMock<Hello>(resource: "/hello")

    sut.request(with: endpoint) { result in

      guard let resultData = try? result.get() else {
        XCTFail("Should return proper response")
        return
      }

      XCTAssertEqual(resultData.message, "Bonjour")
      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 0.1)
  }

  func test_whenInvalidResponse_shouldThrowError() {
    let config = NetworkConfigurableMock()
    let session = NetworkSessionableMock(configurable: config)
    let network = Network(sessionable: session)

    let sut = NetworkService(provider: network)

    let expectation = self.expectation(description: "Should return correct error")

    let endpoint = EndpointMock<Hello>(resource: "/hello")

    sut.request(with: endpoint) { result in
      do {
        _ = try result.get()
        XCTFail("Should not pass here")
      }
      catch let error {
        guard case ParsingError.empty = error else {
          XCTFail("Incorrect Error handled")
          return
        }
        expectation.fulfill()
      }
    }

    wait(for: [expectation], timeout: 0.1)
  }

  func test_whenBadRequest_shouldThrowNetworkError() {
    let config = NetworkConfigurableMock()
    let expectedError = NSError(domain: "error", code: NSURLErrorUnknown)
    let session = NetworkSessionableMock(configurable: config, error: expectedError)
    let network = Network(sessionable: session)

    let sut = NetworkService(provider: network)

    let expectation = self.expectation(description: "Should return correct error")

    let endpoint = EndpointMock<Hello>(resource: "/hello")

    sut.request(with: endpoint) { result in
      do {
        _ = try result.get()
        XCTFail("Should not pass here")
      }
      catch let error {
        guard case NetworkError.requestError(let e) = error, e?._code == expectedError.code else {
          XCTFail("Incorrect Error handled")
          return
        }
        expectation.fulfill()
      }
    }

    wait(for: [expectation], timeout: 0.1)
  }
}
