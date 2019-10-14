//
//  NetworkProvider.swift
//  WeatherApp
//
//  Created by Ronaël Bajazet on 13/10/2019.
//  Copyright © 2019 Ro42e0 Company. All rights reserved.
//

import Foundation

// MARK: Requestable
enum HttpMethod {
  case get
  case post
}
enum Encoding {
  case url
  case json
}
typealias Parameters = [String: Any]

protocol Requestable {
  var resource: String { get }
  var method: HttpMethod { get }
  var parameters: Parameters { get }
  var encoding: Encoding { get }
}

// MARK: NetworkConfigurable
protocol NetworkConfigurable {
  var baseURL: String { get }
  var headers: [String: String] { get }
  var timeout: TimeInterval { get }
}

// MARK: NetworkRequest
typealias RequestCompletion = (Swift.Result<Any, Error>) -> Void

protocol NetworkRequest {
  func execute(completion: @escaping RequestCompletion)
  func cancel()
}

// MARK: NetworkSessionable
protocol NetworkSessionable {
  var configuration: NetworkConfigurable { get }
  init(configurable: NetworkConfigurable)
  func request(from requestable: Requestable) throws -> NetworkRequest
}

// MARK: NetworkProvider
enum NetworkError: Error {
  case statusCode(Int)
  case timedOut
  case notConnected
  case invalidURL
  case requestError(Error?)
}
typealias NetworkCompletion = (Result<Data?, NetworkError>) -> Void

protocol NetworkProvider {
  init(sessionable: NetworkSessionable)
  func request(requestable: Requestable, completion: @escaping NetworkCompletion)
}

// MARK: Networkable
protocol Networkable {
  init(provider: NetworkProvider)
}
