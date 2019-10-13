//
//  NetworkService.swift
//  WeatherApp
//
//  Created by Ronaël Bajazet on 13/10/2019.
//  Copyright © 2019 Ro42e0 Company. All rights reserved.
//

import Foundation

enum ParsingError: Error {
  case empty
  case format
}

class GenericEndpoint<T: Any>: Endpoint {}

protocol NetworkServiceProvider: Networkable {
  func request<T: Decodable>(with endpoint: GenericEndpoint<T>, completion: @escaping (Result<T, Error>) -> Void)
  func request<T: Decodable>(with endpoint: GenericEndpoint<T>, on queue: DispatchQueue, completion: @escaping (Result<T, Error>) -> Void)
}

class NetworkService: NetworkServiceProvider {
  private let network: NetworkProvider

  required init(provider: NetworkProvider) {
    network = provider
  }

  func request<T>(with endpoint: GenericEndpoint<T>, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
    self.request(with: endpoint, on: .main, completion: completion)
  }

  func request<T>(with endpoint: GenericEndpoint<T>, on queue: DispatchQueue, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
    network.request(requestable: endpoint) { result in
      switch result {

      case .success(let response):
        guard let data = response else {
          queue.async { completion(.failure(ParsingError.empty)) }
          return
        }

        do {
          let decoder = JSONDecoder()
          let result = try decoder.decode(T.self, from: data)
          queue.async { completion(.success(result)) }
        }
        catch {
          queue.async { completion(.failure(ParsingError.format)) }
        }

      case .failure(let error):
        queue.async { completion(.failure(error)) }
      }
    }
  }
}
