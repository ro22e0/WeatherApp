//
//  Network+Alamofire.swift
//  WeatherApp
//
//  Created by Ronaël Bajazet on 13/10/2019.
//  Copyright © 2019 Ro42e0 Company. All rights reserved.
//

import Foundation
import Alamofire

class AlamofireSession: NetworkSessionable {
  var configuration: NetworkConfigurable

  lazy var manager: SessionManager = {
    let conf = URLSessionConfiguration.default
    conf.timeoutIntervalForRequest = configuration.timeout
    conf.timeoutIntervalForResource = configuration.timeout
    conf.httpAdditionalHeaders = configuration.headers
    conf.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData

    return SessionManager(configuration: conf)
  }()

  required init(configurable: NetworkConfigurable) {
    configuration = configurable
  }

  func request(from requestable: Requestable) throws -> NetworkRequest {
    var encoding: ParameterEncoding
    var method: HTTPMethod

    if requestable.encoding == .json {
      encoding = JSONEncoding.default
    } else {
      encoding = URLEncoding.default
    }

    if requestable.method == .post {
      method = .post
    } else {
      method = .get
    }

    guard let url = url(endpoint: requestable.resource) else {
      throw NetworkError.invalidURL
    }

    let request = manager.request(url, method: method,
                                  parameters: requestable.parameters, encoding: encoding)
    Logger.info(request.description)
    return AFDataRequest(request)
  }

  private func url(endpoint: String) -> URL? {
    let baseURL = configuration.baseURL
    let fullURL = baseURL.last == "/" ? "\(baseURL)\(endpoint)" : "\(baseURL)/\(endpoint)"
    return URL(string: fullURL)
  }
}

extension AlamofireSession {
  class AFDataRequest: NetworkRequest {

    private var request: DataRequest

    init(_ request: DataRequest) {
      self.request = request
    }

    func execute(completion: @escaping RequestCompletion) {
      request.validate().responseData { response in
        switch response.result {
        case .success(let data):
          completion(.success(data))
        case .failure(let error):
          completion(.failure(error))
        }
      }
    }

    func cancel() {
      request.cancel()
    }
  }
}
