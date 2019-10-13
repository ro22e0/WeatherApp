//
//  Network.swift
//  WeatherApp
//
//  Created by Ronaël Bajazet on 13/10/2019.
//  Copyright © 2019 Ro42e0 Company. All rights reserved.
//

import Foundation

class Network: NetworkProvider {

  private let session: NetworkSessionable

  required init(sessionable: NetworkSessionable) {
    session = sessionable
  }

  func request(requestable: Requestable, completion: @escaping NetworkCompletion) {
    do {
      let request = try session.request(from: requestable)
      request.execute { response in
        var error: NetworkError
        switch response {

        case .success(let data):
          Logger.info("Network Success: \(String(describing: data))")
          completion(.success(data as? Data))

        case .failure(let requestError):
          Logger.error("Network Error: \(requestError.localizedDescription)")

          let errorCode = requestError._code

          if errorCode == NSURLErrorNotConnectedToInternet {
            error = .notConnected
          } else if errorCode == NSURLErrorTimedOut {
            error = .timedOut
          } else if (300...500).contains(errorCode) {
            error = .statusCode(errorCode)
          } else {
            error = .requestError(requestError)
          }
          completion(.failure(error))
        }
      }
    }
    catch (let error as NetworkError) {
      completion(.failure(error))
    }
    catch (let error) {
      completion(.failure(.requestError(error)))
    }
  }
}
